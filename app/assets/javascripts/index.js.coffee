#currently shown elements
shown_el = []; tbody_el = null;

#rows that are not hidden on page change(must be on top)
static_rows_count = 1

#build currently shown, starting right after form-row(this is always on page so is not toggled)
iter_el = (tbody_el = $('tbody')[0]).firstElementChild.nextElementSibling
while iter_el && iter_el.style.display != 'none'
  shown_el.push iter_el
  iter_el = iter_el.nextElementSibling

#maximum rows per page
max_rows = parseInt((document.getElementById('pages-counter')).dataset.rowsPerPage)

#page number element
pgNumLabelEl = null

#update dom and shown_el for page changes and row insertions, shown_el is the first processed element
iterateEl = (first_el, page = null, reverse = false, max = max_rows) ->
  iter = first_el

  #update page number label
  unless page is null
    (pgNumLabelEl ?= document.getElementById('page-number-label')).innerHTML = "Page #{page}"

  #update shown/hidden
  el.style.display = 'none' for el in shown_el
  shown_el = []; count = 0;
  while iter && count < max
    is_row_form = false
    iter.style.display = 'table-row' unless (is_row_form = (iter.id == 'row-form'))
    if reverse
      shown_el.unshift iter unless is_row_form
      iter = iter.previousElementSibling
    else
      shown_el.push iter unless is_row_form
      iter = iter.nextElementSibling
    count++ unless is_row_form

#replace numbered row, update row number column for new row, and replace shown_el array reference
replaceRow = (old_row, new_row) ->
  row_num = parseInt ($old_row = $(old_row)).find('td')[0].innerHTML #get rownum
  $old_row.replaceWith ($new_row = $(new_row))
  $new_row.find('td')[0].innerHTML = row_num #set rownum
  shown_el[(row_num % max_rows) - static_rows_count] = $new_row[0] #update shown_el array reference

$('.pagination-control-group')
  .on 'click', '#next-page', ->
    if shown_el[shown_el.length - 1].nextElementSibling
      iterateEl shown_el[shown_el.length - 1].nextElementSibling, (parseInt((pgNumLabelEl ?= document.getElementById('page-number-label')).innerHTML.match(/\d+/g)[0]) + 1)
  .on 'click', '#prev-page', ->
    if shown_el[0].previousElementSibling.id != 'row-form'
      iterateEl shown_el[0].previousElementSibling, (parseInt((pgNumLabelEl ?= document.getElementById('page-number-label')).innerHTML.match(/\d+/g)[0]) - 1), true
  .on 'click', '#first-page', ->
    iterateEl $('tbody')[0].firstElementChild.nextElementSibling, 1
  .on 'click', '#last-page',  ->
    iterateEl ($tbody = $('tbody'))[0].children[$tbody[0].children.length - static_rows_count], Math.ceil(($tbody[0].children.length - 1) / max_rows), true, (if (lp = ($tbody[0].children.length - 1) % max_rows) is 0 then max_rows else lp)
  .on 'click', '.individual-pg-control', ->
    iterateEl $('tbody')[0].children[((pg = parseInt(this.dataset.page)) * max_rows) + static_rows_count], pg + 1

$('table')
  #toggle danger class and replace buttons for delete/undo row
  .on 'ajax:success', '[data-method="delete"], [data-method="post"]', (evt, data) ->
    ($tr = $(this).parents('tr')).toggleClass('danger')
    $tr[0].lastElementChild.innerHTML = data

  #new model row appending
  .on 'ajax:success', '.form-row[method="post"]', (evt, data) ->
    #append new row after form_row or before the current shown_el and hide/show
    if shown_el.length == 0
      $(tbody_el.firstElementChild).after($(data)[2])
      iterateEl tbody_el.firstElementChild.nextElementSibling
    else
      shown_el[0].className = '' if shown_el[0].className == 'new-ajax-row'  #only one new row per page
      $(shown_el[0]).before($(data)[2])
      iterateEl shown_el[0].previousElementSibling

    #update row numbers from insertion point(starts from first new row added)
    start_count = if shown_el[0].previousElementSibling.id == 'row-form' then 0 else parseInt(shown_el[0].previousElementSibling.firstElementChild.innerHTML)
    iter = shown_el[0].previousElementSibling
    while (iter = iter.nextElementSibling) && (start_count = start_count + 1)
      if (td = iter.firstElementChild).tagName == 'TD'
        td.innerHTML = start_count
      else
        td.nextElementSibling.innerHTML = start_count #workaround for open edit_row edge case

    #replace old form_row
    $(this.parentElement).replaceWith $(data)[0]

    #update model counter above table
    (document.getElementById('models-counter')).innerHTML = tbody_el.children.length - 1

    #add pages if tbody element length has a remainder of 1 or if max_rows is 1. Last term is to account for the page number having a minimum of 1 button
    if ((tbody_el.children.length - 1) % max_rows == 1 || max_rows == 1) && (tbody_el.children.length - 1) > max_rows
      new_page = parseInt((document.getElementById('pages-counter')).innerHTML) + 1
      (document.getElementById('pages-counter')).innerHTML = new_page

      #create a new page button if page buttons are shown
      if $('.pagination-control-group .individual-pg-control').length > 0
        new_button = $('.pagination-control-group button:first-child').clone()[0]
        new_button.dataset.page = new_page - 1
        new_button.firstElementChild.innerHTML = new_page
        $('.pagination-control-group').append new_button

  #show form-row errors
  .on 'ajax:error', '.form-row[method="post"]', (evt, xhr) ->
    $(this.parentElement).replaceWith(xhr.responseText)

  #show edit row form for existing rows or cancel edit and set rownum
  .on 'ajax:success', '.row-edit, .cancel-edit, .form-edit-row', (evt, data) ->
    replaceRow $(this).parents('tr')[0], data

  .on 'ajax:error', '.form-edit-row', (evt, xhr) ->
    replaceRow $(this).parents('tr')[0], xhr.responseText

  #clear a row form's input
  .on 'click', 'td .clear-input', ->
    $(this.parentElement.parentElement.parentElement.children).find('input[type="text"]').val('')

  #remove a deleted numbered row from dom
  .on 'click', 'td .remove-row', ->
    remove_row_num = parseInt ($row = $(this).parents('tr')).find('td')[0].innerHTML #get rownum
    shown_el.splice (remove_row_num - 1)

    iter_tr = $row[0]
    while (iter_tr = iter_tr.nextElementSibling)
      td_el = if iter_tr.children[0].tagName is 'TD' then iter_tr.children[0] else iter_tr.children[1]
      td_el.innerHTML = (row_num = (parseInt(td_el.innerHTML) - 1))
      unless shown_el.length >= max_rows
        shown_el[row_num - 1] = td_el.parentElement
        td_el.parentElement.style.display = 'table-row'

    $row.remove()

    if (len = tbody_el.children.length - static_rows_count) > 1 && len % max_rows == 0
      (pg_el = document.getElementById('pages-counter')).innerHTML = parseInt(pg_el.innerHTML) - 1
      $('.pagination-control-group .individual-pg-control:last').remove()

    #update model counter above table
    (document.getElementById('models-counter')).innerHTML = tbody_el.children.length - static_rows_count