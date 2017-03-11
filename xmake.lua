-- the debug mode
if is_mode("debug") then
    
    -- enable the debug symbols
    set_symbols("debug")

    -- disable optimization
    set_optimize("none")
end

-- the release mode
if is_mode("release") then

    -- set the symbols visibility: hidden
    set_symbols("hidden")

    -- enable fastest optimization
    set_optimize("fastest")

    -- strip all symbols
    set_strip("all")
end

-- the parameters for compile and build
if is_plat("macosx") then
    add_ldflags("-framework Foundation", "-framework CoreFoundation")
    --add_ldflags("-fobjc-arc", "-fobjc-link-runtime");
    add_mxxflags("-std=c++11")
elseif is_plat("windows") then
    add_defines("UNICODE", "_UNICODE", "_USING_V110_SDK71_")
    if is_mode("release") then
        add_defines("NDEBUG")
    end
    add_cxxflags("/Zc:wchar_t", "/Zc:inline", "/Gd", "/EHsc", "/O2", "/Oi", "/Oy-", "/GL")
    add_cxxflags("/Gy", "/Gm-", "/Zc:forScope", "/GL", "/analyze-", "/fp:precise", "/WX-")
    add_ldflags("/OPT:REF", "/OPT:ICF", "/LTCG:incremental", "/MACHINE:X86", "/SAFESEH")
    add_ldflags("/DYNAMICBASE", "/INCREMENTAL:NO", "/SUBSYSTEM:WINDOWS,5.01")
    add_ldflags("kernel32.lib", "user32.lib", "gdi32.lib", "winspool.lib", "comdlg32.lib")
    add_ldflags("advapi32.lib", "shell32.lib", "ole32.lib", "oleaut32.lib", "uuid.lib")
end

-- add target
target("todolist")
set_kind("binary")
add_cxxflags("-std=c++11")
add_includedirs("src", "sciter/include")
add_files("src/*.cpp")
add_files("sciter/include/behaviors/behavior_tabs.cpp")
add_files("sciter/include/behaviors/behavior_video_generator.cpp")
add_files("sciter/include/behaviors/behavior_drawing.cpp")
if is_plat("macosx") then
    add_ldflags("-framework Cocoa", "-framework WebKit")
    add_ldflags("sciter/osx/sciter-osx-64.dylib")
    add_mxxflags("-std=c++11")
    --add_linkdirs("sciter/osx")
    --add_links("sciter-osx-64")
    add_files("src/osx/*.mm")
    add_files("sciter/include/sciter-osx-main.mm")
elseif is_plat("windows") then
    add_includedirs("src/win")
    add_ldflags("sciter/win32/sciter.lib")
    add_files("src/win/*.cpp")
    add_files("sciter/include/sciter-win-main.cpp")
    add_files("sciter/include/behaviors/behavior_drawing-opengl.cpp")
    add_files("sciter/include/behaviors/behavior_drawing-gdi.cpp")
    --add_files("sciter/include/behaviors/behavior_camera_capture.cpp")
    after_build(function()
        os.run("mt.exe -manifest src/PerMonitorHighDPIAware.manifest -outputresource:build/todolist.exe;1")
    end);
end

