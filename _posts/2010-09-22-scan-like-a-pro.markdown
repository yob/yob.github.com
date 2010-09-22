---
layout: default
---
Several years ago I read an
[article](http://onlamp.com/pub/a/onlamp/2006/11/02/personal_document_management.html)
on scanning personal paperwork and reducing physical clutter. I liked the
concept (except the part about using perforce!) and have since refined my own
workflow to acheive something similar.

These days I scan and OCR nearly all paperwork I deal with (bills, contracts,
letters, statements, etc), store them in a shallow directory structure and
commit them to a git repository.

## Step One: Scanner

For scanning, I use a document scanner at a clients office. I'm there a couple
of days a week, so every now and again I take a pile of paper in and feed it
through. They have a [Xerox DocuCentre-II
C2200](http://www.support.xerox.com/SRVS/CGI-BIN/WEBCGI.EXE?New,Kb=x_WC7245_en,Company={683D76C8-B5C5-416E-9754-DD015FDB4F2E},ts=x_main_en,ques=ref%28Country%29:str%28AUS%29,ques=ref%28Prod_WC7228_WC7235_WC7245%29:str%28DC_C2200_C3300%29,question=ref%28ProdFamily%29:str%28Prod_WC7228_WC7235_WC7245%29,varset=Xcntry:AUS,varset=Xlang:en_AU,varset=prodID:DC_C2200_C3300,varset=prodName:DocuCentre-II%20C2200/C3300)
- it can scan 50 double sided pages at a time and saves the PDFs to a windows
share. Depending on the document, I scan in colour or greyscale at 600 dpi -
the saved files are larger, but I deal with that later.

## Step Two: OCR

The resulting PDFs have a single scanned image per page - I really wanted to
OCR them if possible and make the content searchable. I explored various open
source options that could run on my Linux systems, but none worked as well as I
hoped. They generally had accuracy issues or could only output the recognised
characters to a text file.

A few years ago I was working at a University, so I splashed out on an academic
copy of Adobe Acrobat Pro 9.0 for Windows. Dual booting is a pain, but the OCR
support is second to none and makes the hassle worthwhile.

*****
Version 9.0 or later of Acrobat Pro have an OCR feature called ClearScan.
After recognising the characters on each page, it converts them to a custom
vector font and *replaces* the scanned image of that character with the vector
character. This makes the text indexable by standard PDF search tools (like
spotlight, etc) and has an massive impact on the file size. A 24 page text only
document I scanned last week went from 11Mb to 700Kb.

To use ClearScan, open the scanned PDF, select ...
*****

## Step Three: Git

As a final step I store the files in a simple directory structure and save them
to a git repository. A version control system might seem a bit odd, as the
files generally don't change much (if at all) but git makes it easy to store a
backup of all the files on my server.

I group the documents by type and year. Anything more complex is unnecesary as
I usually find what I need by searching. Here's a sample of the directory
structure:

    banking/2010/20100630 - statement.pdf
    banking/2010/20100720 - letter.pdf
    banking/2010/20100731 - statement.pdf
    insurance/2009/20090317 - contents renewal.pdf
    insurance/2010/20100315 - contents renewal.pdf
    receipts/2010/20100915 - laptop.pdf

## Step Four: Profit

Here are some ways having these documents scanned has come in handy.

* For my last two tax returns I've just zipped up the relevant scanned files
  and emailed them to my accountant. No visit was necesary.
* Every few months I wonder if my motor bike is due for a service, so I lookup
  the receipt for the last service
* After an accident last month, my insurer wanted receipts for my bike helmet
  and shoes. I sent them as email attachments on the same day.
* A few weeks ago I looked back over 3 years of electricity bills to see how my
  usage and the charges had changed.
* I don't have piles of paperwork taking up space on my desk
