workspace("RunInBackground_Workspace")
	configurations {"Debug", "Release", "Release_Debug"}
	platforms {"Windows_x64"}
	characterset "Unicode"
	language "C++"
	cppdialect "C++latest"
	systemversion "latest"
	rtti "Off"
	warnings "Default"
	targetdir "./bin/%{cfg.buildcfg}_%{cfg.platform}"
	objdir "./obj/%{prj.name}/%{cfg.buildcfg}_%{cfg.platform}"
	debugdir(os.getcwd())
	startproject("RunInBackground")

	flags {
		"FatalWarnings",
		"MultiProcessorCompile",
	}

	filter "action:vs*"
		buildoptions{
			"/wd4996", -- Disable some warnings about things Visual Studio has taken apon itself to deem "deprecated"
			"/wd4103", -- Work around for MSVC bug. TODO: remove when fixed - https://developercommunity.visualstudio.com/t/Warning-C4103-in-Visual-Studio-166-Upda/1057589
			"/w14132", -- Enable: const object should be initialized
			"/w14189", -- Enable: local variable is initialized but not referenced
			"/w14456", -- Enable: declaration hides previous local declaration
			"/w14457", -- Enable: declaration hides function parameter
			"/w14700", -- Enable: uninitialized local variable used
			"/w14701", -- Enable: potentially uninitialized local variable 'name' used
			"/w14714", -- Enable: function marked as __forceinline not inlined
			"/w15038", -- Enable: out of order initialization warnings. Bugs related to this can be tricky to track down.
		}

	filter "platforms:Windows_x64"
        architecture "x64"
		defines {
			"WIN32_LEAN_AND_MEAN",
			"NOMINMAX",
			"VC_EXTRALEAN",
		}

	filter "configurations:Debug*"
		symbols "On"
		defines {"DEBUG"}
		inlining "Explicit"
		editandcontinue "Off" -- As of Visual Studio 16.7 MSVC uses /ZI (capital i) by default which prevents /Ob1 (__forceinline) from working. See https://developercommunity.visualstudio.com/t/major-debug-performance-regression-ob1-no-longer-w/1177277#T-N1188009

	filter "configurations:Release*"
		symbols "Off"
		optimize "Size"
		inlining "Auto"
		defines {"NDEBUG"}
		flags {"LinkTimeOptimization"}

	filter {"configurations:Release*", "action:vs*"}
		inlining "Default" -- To avoid D9025
		buildoptions {"/Ob3"}

	filter "configurations:Release_Debug"
		symbols "On"

project("RunInBackground")
	uuid "368CE0A0-22DC-4D08-B43F-34F97FEB6D82"
	kind "WindowedApp"
	files { "main.cpp" }
	includedirs { "src" }
	links {}
	libdirs {}
