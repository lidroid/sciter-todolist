#include "sciter-x.h"
#include "sciter-x-behavior.h"
#include "sciter-x-window.hpp"

#import <WebKit/WebKit.h>

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

            NSView *view = (__bridge NSView *)el.get_element_hwnd(false);
            NSWindow *window = [view window];
            NSRect rect = [window contentRectForFrameRect:[view frame]];

			browser = [[WebView alloc] initWithFrame:rect];
            [view addSubview:browser];
			el.attach_hwnd((__bridge void *)browser);
		}

		virtual void detached(HELEMENT he)
		{
			if (browser) {
				//[browser release];
				browser = NULL;
			}

			self = 0;
			dom::element el = he;
			el.attach_hwnd(0);
			delete this;
		}

		value navigate(const value &url_val)
		{
			NSString *url = [[NSString alloc] initWithUTF8String:aux::w2a(url_val.get(WSTR("about:blank")))];
			if (browser) {
                [[browser mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            }

			return value();
		}

		value back()
		{
			if (browser) {
                [browser goBack];
            }

			return value();
		}

		value forward()
		{
			if (browser) {
                [browser goForward];
            }

			return value();
		}

		value refresh()
		{
			if (browser) {
                [[browser mainFrame] reload];
            }

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
		WebView *browser;
	};

	webview webview_factory;
}
