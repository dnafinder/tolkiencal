Tolkiencal — Shire Calendar Converter for MATLAB  
_A tribute to J.R.R. Tolkien by Giuseppe Cardillo_

## Overview
**Tolkiencal** converts a Gregorian date into the **Shire Reckoning**, the calendar used by the Hobbits of the Shire.  
It reproduces the structure described in *The Lord of the Rings – Appendix D*, including:

- 12 months of 30 days  
- Yule and Lithe festival days  
- Midyear’s Day and Overlithe  
- Weekdays fixed in position every year (due to Shire Reform)

This implementation assumes that **Midyear's Day corresponds to the summer solstice** on **21 June**, valid approximately from **1600 to 2399 A.D.**

---

## Features (2025 Updated Version)
This modernized version includes:

- ✔️ Support for `datetime`, `datenum`, and date strings  
- ✔️ Native `datetime` parsing and validation  
- ✔️ Optional return value (string)  
- ✔️ Backward-compatible printing behaviour  
- ✔️ Replaced custom `rldecode` with MATLAB’s native `repelem`  
- ✔️ Cleaner, safer code structure  
- ✔️ Fully documented logic with clear assumptions  
- ✔️ Updated author email  
- ✔️ Updated citation with GitHub link

---

## Syntax

```matlab
tolkiencal()
tolkiencal(date)
tolkiencal(date, format)
shireStr = tolkiencal(...)

Accepted input types

datetime

datenum

char / string date, e.g. '04/06/2007'


Supported date formats

'dd-mmm-yyyy'
'mm/dd/yy'
'mmm.dd,yyyy'
'mm/dd/yyyy'
'dd/mm/yyyy'
'yy/mm/dd'
'yyyy/mm/dd'


---

Examples

tolkiencal('04/06/2007')
% → Hevensday 15 Forelithe 2007

d = datetime(1954,9,21);
tolkiencal(d)

To capture the result as a string:

s = tolkiencal('21/06/2024')


---

Citation

If you use this script in academic work, please cite:

Cardillo G. (2007–2025). 
Tolkiencal: convert a date into the Shire calendar.
https://github.com/dnafinder/tolkiencal


---

Author

Giuseppe Cardillo
giuseppe.cardillo.75@gmail.com


---

License

MIT License — see LICENSE file.

---
