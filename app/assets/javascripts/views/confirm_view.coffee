class HCI.ConfirmView extends Backbone.View
  template: JST['confirm_choice']
  
  events: ->
    'changeStimuli': 'changeStimuli'
    'click #back': 'back'
    'click #confirm': 'confirm'

  className: 'experiment'

  initialize: (options) ->
    @result = options.result
    @stimuli_id = options.stimuli_id
    @current_stimuli = @stimuli_id

  render: ->
    @$el.html(@template())
    @stimuli_view = new HCI.StimuliView(active_stimuli: @stimuli_id, stimuli_number: @model.results.size())
    @controls_view = new HCI.ConfirmControlsView(active_stimuli: @stimuli_id)
    @$('#stimuli').html(@stimuli_view.render().el)
    @$('#confirm_controls').html(@controls_view.render().el)
    @$('h3').text('Confirm selection')
    this

  changeStimuli: (event) ->
    @current_stimuli = $(event.target).attr('data-stimuli-number')
    @stimuli_view.showStimuli($(event.target).attr('data-stimuli-number'))

  confirm: (event) ->
    @end()
    @remove()
    if @model.results.size() == 10
      post_test_view = new HCI.PostTestQuestionnaireView(model: @model)
      $('#forms').html(post_test_view.render().el)
    else
      priming_view = new HCI.PrimingView(model: @model)
      $('#forms').html(priming_view.render().el)

  end: ->
    @result.set('end_time', new Date())
    @result.set('subject_answer', @current_stimuli)
    @result.save()

  back: ->
    experiment_view = new HCI.ExperimentView(model: @model, result: @result, stimuli_id: @current_stimuli)
    @remove()
    $('#experiment').html(experiment_view.render().el)
