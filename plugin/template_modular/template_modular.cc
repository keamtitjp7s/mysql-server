/*
  Copyright (c) 2006, 2026, Oracle and/or its affiliates.

  Template: Modular Plugin for Cross-Platform / Structural Integration

  Purpose:
    Demonstrates how to build a minimal, clean plugin that can be embedded
    into other platforms or structures using MODULE_ONLY mode.

  Build (standalone or embedded):
    MYSQL_ADD_PLUGIN(template_modular
      template_modular.cc
      MODULE_ONLY
      MODULE_OUTPUT_NAME "libtemplate_modular"
    )

  Integration:
    - Works with --components build mode
    - No server binary required
    - Uses mysqlservices only
*/

#include <mysql/plugin.h>
#include <mysql/services/mysql_service_plugin_registry.h>

/* Plugin descriptor for dynamic loading */
static struct st_mysql_plugin template_plugin_descriptor = {
    MYSQL_PLUGIN_INTERFACE_VERSION,
    "template_modular",
    MYSQL_STATUS_PLUGIN_ON,
    MYSQL_PLUGIN_TYPE_DAEMON,
    nullptr,
    nullptr,
    1,
    nullptr,
    nullptr,
    0,
};

mysql_declare_plugin(template_modular)
{
    MYSQL_PLUGIN_INTERFACE_VERSION,
    "template_modular",
    MYSQL_STATUS_PLUGIN_ON,
    MYSQL_PLUGIN_TYPE_DAEMON,
    nullptr,
    nullptr,
    1,
    nullptr,
    nullptr,
    0,
}
mysql_declare_plugin_end;
