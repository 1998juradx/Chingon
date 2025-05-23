$(document).ready(function(){
  $(".openclose").each(function(e){
    if ($(this).hasClass("close")){
      $(this).find("ol").hide(250);
      var text = $(this).find("legend").find("span").text()
      text += " (Abrir)"
      $(this).find("legend").find("span").text(text)
    }
    else{
      $(this).addClass("open");
      var text = $(this).find("legend").find("span").text()
      text += " (Cerrar)"
      $(this).find("legend").find("span").text(text)
    }

  })
  $(".openclose").find("legend").click(function(){
    $(this).siblings("ol").toggle(250);
    if ($(this).parent().hasClass("open")){
      var text = $(this).find("span").text()
      text = text.replace("Cerrar", "Abrir");
      $(this).find("span").text(text);
      $(this).parent().removeClass("open");
      $(this).parent().addClass("close");
    }
    else{
      var text = $(this).find("span").text()
      text = text.replace("Abrir", "Cerrar");
      $(this).find("span").text(text);
      $(this).parent().removeClass("close");
      $(this).parent().addClass("open");
    }
  })
  if (window.location.pathname.indexOf("user_companies") >= 0){
  
    const urlParams = new URLSearchParams(window.location.search);
    const type_user = urlParams.get('type_user');
  
    // $(".action_item").hide();
    if (type_user){
      $(".menu_item").removeClass("current")
      // $(".correctivo").show();
      $("#administradores").addClass("current")
      $("#page_title").text("Administradores")
      $(".action_item a").text("Añadir administrador")
      $("#new_q").append(`<input type='hidden' name='type_user' value='${type_user}' />`)
  
      // if ($("#edit_maintenance").length){
      //   $("#edit_maintenance").prop("action", `${$("#edit_maintenance").prop("action")}?kind=correctivo`);
      // }
      // $(".scope-default-group").css({width: "80%"})
      // $(".scope-default-group li.scope").css({width: "200px"})
  
  
      const anchors = document.querySelector("#active_admin_content").querySelectorAll("a");
      for (let i = 0; i < anchors.length; i++) {
        const anchor = anchors[i];
        if (anchor.href.indexOf("administradores") >= 0){
          if (anchor.href.indexOf("?") >= 0){
            anchor.href = `${anchor.href}&type_user=2`
          }
          else{
            anchor.href = `${anchor.href}?type_user=2`
          }
        }
      }
    }
    else{
      // $(".preventivo").show();
      $("#page_title").text("Aspirantes y Estudiantes")
      // $("#new_q").append(`<input type='hidden' name='kind' value='preventivo' />`)
    }
  }
})


function rolValidationChecks(role){
  if (role.indexOf("b2b") >= 0){
    $("#users").hide()
  }

}
