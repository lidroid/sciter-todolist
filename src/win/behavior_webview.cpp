#include "stdafx.h"
#include "sciter-x.h"
#include "sciter-x-behavior.h"
#include "sciter-x-window.hpp"

#include "WebBrowser.h"

namespace sciter
{
	struct webview : public event_handler, behavior_factory
	{
	public:
		webview() : event_handler(), behavior_factory("webview"), self(0), browser(NULL) {}

		virtual event_handler *create(HELEMENT he) { return new webview(); }

		virtual void attached(HELEMENT he)
		{
			self = he;
			dom::element el = he;

			browser = new WebBrowser(el.get_element_hwnd(true));

			el.attach_hwnd(browser->GetControlWindow());
		}

		virtual void detached(HELEMENT he)
		{
			if (browser) {
				delete browser;
				browser = NULL;
			}

			self = 0;
			dom::element el = he;
			el.attach_hwnd(0);
			delete this;
		}

		value navigate(const value &url_val)
		{
			std::wstring url = url_val.get(L"about:blank");
			if (browser) browser->Navigate(url);

			return value();
		}

		value back()
		{
			if (browser) browser->GoBack();

			return value();
		}

		value forward()
		{
			if (browser) browser->GoForward();

			return value();
		}

		value refresh()
		{
			if (browser) browser->Refresh();

			return value();
		}

		BEGIN_FUNCTION_MAP
			FUNCTION_1("navigate", navigate)
			FUNCTION_0("back", back)
			FUNCTION_0("forward", forward)
			FUNCTION_0("refresh", refresh)
		END_FUNCTION_MAP

	private:
		HELEMENT self;
		WebBrowser *browser;
	};

	webview webview_factory;
}
