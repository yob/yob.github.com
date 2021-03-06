---
layout: post
---
One small part of my current job involves maintaining a legacy MS Access XP
database, and I recently ran into an issue that caused some consternation.

In all the documentation I could find, the maximum length of a Memo field was
64K when the data was entered via the UI, and 1Gb when entered
programatically. However the app was raising an error when I tried to insert
more than 64K programatically. The field in question was in a linked table,
with the actual table residing inside another access database.

The error I was getting was "Error 3035 - system resource exceeded".

I used the following VBA method to test the theory. Most functions in the 
database use the old [DAO](http://en.wikipedia.org/wiki/Data_Access_Objects)
instead of [ADO](http://en.wikipedia.org/wiki/ActiveX_Data_Objects) for legacy
reasons. We haven't had enough reason to go through the pain of switching
everything to ADO as yet. The error is raised by the db.Execute line.

{% highlight vbnet %}
    Sub testMemoSizeLimit()
      Dim db As Database
      Dim rs As Recordset
      Dim sql As String
      Dim i As Long

      Set db = CurrentDb()

      i = 0
      sql = "INSERT INTO mailQueue(bodyText) VALUES("""

      While i < 70000
        sql = sql & "a"
        i = i + 1
      Wend

      sql = sql & """)"

      db.Execute sql, dbFailOnError
      db.close
    End Sub
{% endhighlight %}

By switching the test function over to ADO, I can now insert more than 64K into my memo field.

{% highlight vbnet %}
    Sub testMemoSizeLimitADO()
      Dim db As ADODB.Connection

      Dim sql As String
      Dim i As Long

      Set db = New ADODB.Connection
      db.Open "Provider='Microsoft.JET.OLEDB.4.0';Data Source='c:\database.mdb';"

      i = 0
      sql = "INSERT INTO mailQueue(bodyText) VALUES("""

      While i < 70000
        sql = sql & "a"
        i = i + 1
      Wend

      sql = sql & """)"

      db.Execute sql, dbFailOnError
      db.close
    End Sub
{% endhighlight %}

The lesson? Use [ADO](http://en.wikipedia.org/wiki/ActiveX_Data_Objects) whenever possible.
