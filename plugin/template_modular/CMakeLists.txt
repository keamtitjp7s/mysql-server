# Copyright (c) 2006, 2026, Oracle and/or its affiliates.
#
# Modular plugin template — easy to embed into other platforms/structures.

MYSQL_ADD_PLUGIN(template_modular
  template_modular.cc
  MODULE_ONLY
  MODULE_OUTPUT_NAME "libtemplate_modular"
  TEST_ONLY
  )

INSTALL(FILES
  template_modular.ini
  DESTINATION ${INSTALL_PLUGINDIR}
  COMPONENT Test
  )
