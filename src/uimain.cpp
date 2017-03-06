#include "sciter-x-window.hpp"

#include "resources.cpp"

class frame : public sciter::window
{
public:
	frame() : window(SW_TITLEBAR | SW_RESIZEABLE | SW_CONTROLS | SW_MAIN | SW_ENABLE_DEBUG) {}
};

int uimain(std::function<int()> run)
{
	frame *pwin = new frame();

	const std::vector<sciter::string> &argv = sciter::application::argv();
	sciter::string str = WSTR("this://app/default.html");
	if (argv.size() > 1)
		str = argv[1];
	else
		sciter::archive::instance().open(aux::elements_of(resources));

	if (pwin->load(str.c_str())) pwin->expand();

	return run();
}
