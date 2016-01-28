$(function() {

  var existingCounter = $(".existing_ingredient").length + 1;
  $("#add-existing-ingredient").on("change",function() {
    $('#new-ingredients').append($('<div/>', {'class': 'form-inline form-group existing_ingredient'})
      .append($('<input>', {'class': 'form-control qty-box', 'name': 'quantity_existing' + existingCounter, 'placeholder': 'Qty'}),
        $('<input>', {'class': 'new-ingredients-box', 'name': 'ingredient_existing' + existingCounter, 'value': $("#add-existing-ingredient").val(), 'hidden': 'true'}),
        $("<label>" + $('#add-existing-ingredient option:selected').text() + "</label>")
      )
    );
    $("#existing_ingredient_count").val(existingCounter);
    existingCounter++;
  });

  var newCounter = $(".new_ingredient").length + 1;
  $("#add-new-ingredient").on("click",function() {
    $('#new-ingredients').append($('<div/>', {'class': 'form-inline form-group new_ingredient'})
      .append($('<input>', {'class': 'form-control qty-box', 'name': 'quantity_new' + newCounter, 'placeholder': 'Qty'}),
        $('<input>', {'class': 'form-control new-ingredients-box', 'name': 'ingredient_new' + newCounter, 'placeholder': 'New ingredient'}))
    );
    $("#new_ingredient_count").val(newCounter);
    newCounter++;
  });
});
