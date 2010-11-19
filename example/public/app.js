
$(document).ready(function() {
  $("select#country").change(function() {
    if (this.value == "---") {
      $("select#city").empty();
      $("select#city").append("<option>---</option>");
      $("select#city").attr('disabled', true);      
    }
    else {
      $.get('/cities/' + this.value, function(data) {
        var cities = JSON.parse(data)["items"];
        console.log(cities);
        
        var html = '';
        var len = cities.length;
        for (var i = 0; i < len; i++) {
          html += '<option value="' + cities[i] + '">' + cities[i] + '</option>';
        }
        $("select#city").empty();
        $("select#city").append("<option>---</option>\n" + html);
        $("select#city").removeAttr('disabled');
      });
    }
  });
});