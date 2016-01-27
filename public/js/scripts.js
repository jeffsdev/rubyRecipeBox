$(function() {
  var counter = $(".new_ingredient").length + 1;
  $("#add-ingredient").on("click",function() {
    $('#new-ingredients').append($('<div/>', {'class': 'form-group new_ingredient'})
                   .append($('<input>', {'class': 'form-control', 'name': 'ingredient' + counter, 'placeholder': 'New ingredient'})));
    $("#ingredient_count").val(counter);
    counter++;
  });
});
