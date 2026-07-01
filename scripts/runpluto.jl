#!julia

using DrWatson
@quickactivate "AAS247Julia"

import Pluto

cd(projectdir("notebooks"))

Pluto.run(
    enable_ai_editor_features = false,
    auto_reload_from_file = true,
)
