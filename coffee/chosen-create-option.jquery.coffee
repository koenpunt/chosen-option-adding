$ = jQuery

class ChosenOptionAdding extends $.fn.chosen.Constructor

  set_default_values: ->
    super
    @create_option = @options.create_option || false
    @persistent_create_option = @options.persistent_create_option || false
    @skip_no_results = @options.skip_no_results || false

  set_default_text: ->
    super
    @create_option_text = @form_field.getAttribute('data-create_option_text') || @options.create_option_text || 'Add option'

  single_set_nosearch: ->
    if @disable_search or @form_field.options.length <= @disable_search_threshold and not @create_option
      @search_field[0].readOnly = true
      @container.addClass 'chosen-container-single-nosearch'
    else
      @search_field[0].readOnly = false
      @container.removeClass 'chosen-container-single-nosearch'

  result_select: (evt) ->
    if @result_highlight
      if @result_highlight.hasClass 'create-option'
        this.select_create_option(@search_field.val())
        return this.results_hide()
      super

  show_create_option: (terms) ->
    create_option_html = $("""<li class="create-option active-result"><a>#{@create_option_text}</a>: "#{terms}"</li>""")
    @search_results.append create_option_html

  create_option_clear: ->
    @search_results.find('.create-option').remove()

  select_create_option: (terms) ->
    if $.isFunction(@create_option)
      @create_option.call this, terms
    else
      this.select_append_option( {value: terms, text: terms} )

  select_append_option: ( options ) ->
    option = $('<option />', options ).attr('selected', 'selected')
    @form_field_jq.append option
    @form_field_jq.trigger 'chosen:updated'
    @form_field_jq.trigger 'change'
    @search_field.trigger 'focus'

  append_option: (option) ->
    this.select_append_option(option)

  no_results: (terms) ->
    super(terms) unless @create_option and @skip_no_results

  keydown_arrow: ->
    if @results_showing and @result_highlight
      next_sib = @result_highlight.nextAll('li.active-result').first()
      this.result_do_highlight next_sib if next_sib
    else if @results_showing and @create_option
      this.result_do_highlight(@search_results.find('.create-option'))
    else
      this.results_show()

  winnow_results: ->
    super
    if @create_option
      this.show_create_option( this.get_search_text() )

$.fn.chosen.Constructor = ChosenOptionAdding