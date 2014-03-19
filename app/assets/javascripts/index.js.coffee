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

#todo: use json or html fragment return type plus undo button with paper trail for deleted rows
$('table')
  .on 'ajax:success', '[data-method="delete"]', (evt, data) ->
    ($tr = $(this).parents('tr')).addClass('danger')
    $tr[0].lastElementChild.innerHTML = data

  .on 'ajax:success', '[method="post"]', (evt, data) ->
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
      iter.firstElementChild.innerHTML = start_count

    #replace old form_row
    $(this.parentElement).replaceWith $(data)[0]

    #update model counter above table
    (document.getElementById('models-counter')).innerHTML = tbody_el.children.length - 1

    #update page counter if last page has a remainder of 1 and add new page button
    if (tbody_el.children.length - 1) % max_rows == 1
      new_page = parseInt((document.getElementById('pages-counter')).innerHTML) + 1
      (document.getElementById('pages-counter')).innerHTML = new_page
      #create new page button if page buttons are shown
      if $('.pagination-control-group .individual-pg-control')
        new_button = $('.pagination-control-group button:first-child').clone()[0]
        new_button.dataset.page = new_page - 1
        new_button.firstElementChild.innerHTML = new_page
        $('.pagination-control-group').append new_button

  .on 'ajax:error', '[method="post"]', (evt, xhr) ->
    $(this.parentElement).replaceWith(xhr.responseText)