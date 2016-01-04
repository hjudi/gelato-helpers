# gelato-helpers
A compact, single-file collection of iOS helpers for various common tasks related to designing modern UIs, social patterns , and more. 

## Installation
Just drop the file into your Xcode project and add it to your target.

## Included
- Quick device info
- UIView frame shortcuts, bulk subview removal
- Compact NSDate “elapsed” parser (“Now”, “5m ago”, “2d ago”)
- UIColor manipulation + string-type hex -> UIColor parser!
- NSAttributedText help: custom line height + alignment generator
- Optional<> Array subscript. No more unpredictable [index] getter.
- Messy JSON value parsers. “True”, “no” -> their bool values.
- Get an array of @-mentioned words in a string!
(“We @all live in the yellow @submarine” -> [“all”,”submarine”])
- Link minification: “https://github.com/hjudi/gelato-helpers” -> “github.com”
- UIImage manipulation: dimWithAlpha() + fillWithColor()
- More UIColor manipulation: darkerByPercentage(), lighterByPercentage(), getRGBA() -> [r,g,b,a], and toImage().