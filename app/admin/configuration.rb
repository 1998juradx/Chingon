# app/admin/Configuraciones.rb (o el nombre de archivo que corresponda)
# frozen_string_literal: true

ActiveAdmin.register_page "Configuraciones" do # Nombre interno de la página
  # Ajusta la prioridad según el orden que desees en el menú
  menu priority: 3, label: proc { I18n.t("ui_elements.configurations") } # <--- USA LA TRADUCCIÓN

  content title: proc { I18n.t("ui_elements.configurations") } do # <--- TÍTULO DE LA PÁGINA TRADUCIDO
    # Aquí va el contenido de tu página de "Configuraciones"
    # Por ejemplo:
    panel I18n.t("active_admin_custom.panels.general_settings") do # Ejemplo de panel
      para "Aquí podrás ajustar las configuraciones generales de la aplicación."
      # Agrega aquí los formularios, tablas o información que necesites para las configuraciones.
    end

    # Ejemplo de un texto que podrías tener:
    # h3 I18n.t("active_admin_custom.titles.system_preferences")
    # para I18n.t("active_admin_custom.messages.configure_options_below")

  end
end