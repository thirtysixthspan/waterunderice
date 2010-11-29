Water under Ice
===============

Resumable, asynchronous file uploads using WebSockets in HTML 5 compliant browsers 


Overview
--------
  It is becoming an increasingly common need to provide website users the ability to upload large or very large files. These uploads can take anywhere from minutes to hours. The standard [form-based upload](http://www.w3.org/TR/html4/interact/forms.html#file-select) provided by HTML is not a suitable solution to meet this demand because the browser blocks during form submission, no information is provided to the user as to the progress or estimated time to completion, and the upload cannot be resumed after interruption. 
  
  [Alternative solutions](http://valums.com/ajax-upload/) involve embedding hidden iframes in the page and submitting a form-based upload from the hidden iframe or using asynchronous XMLHttpRequests (XHR). The primary advantage of these approaches is that the web page does not block, allowing users to enter metadata or perform other activities during upload. Progress and estimated time to completion can also be provided to the user via repeated polling of the server via XHR. Aside from being inelegant solutions, these approached still do not allow uploads to be temporarily paused or resumed after interruption.  A [plugin-based approach using either Java or Flash](http://www.phinesolutions.com/java-applet-vs-flash-based-file-uploader.html) can meet all these needs but can be problematic because of the lack of cross-platform support, stability, and/or security concerns. 
  
  Now that HTML 5 compliant browsers are becoming available, a solution that meets all of these requirements can be achieved without plugins. The solution adopted here is to take advantage of the [File API](http://www.w3.org/TR/FileAPI/) and the [WebSocket protocol](http://en.wikipedia.org/wiki/WebSockets). Using the File API, client-side files can be read, in part or entirety, into memory for manipulation via Javascript. The WebSocket protocol provides a persistent bidirectional communication channel between client and server. Using these features together, small file segments can be read in on the client side and transferred to the server asynchronously. As well as providing non-blocking uploads, this approach permits progress to be determined on the client side without querying the server, and more importantly, uploads can be temporarily paused or resumed after interruption. 
  

Features
--------
File uploads that
 
* support very large files.
* do not block the web page during upload.
* can be paused and resumed at will, even from a later session or machine.
* are delivered via the [WebSocket protocol](http://en.wikipedia.org/wiki/WebSockets).
* do not use Flash, Java, iframes, or XHR. 


Requires
--------
On the client:

* HTML 5 compliant browser
* Jquery >= 1.4.3 (via Google CDN)
* Jquery-ui >= 1.8.4 (via Google CDN)

On the server:

* HTTP server (e.g. Sinatra) 
* WebSocket server (e.g. [em-websockets](http://github.com/igrigorik/em-websocket))


Put in on your website
----------------------
Copy the css and js directories to the public directory of your server.

Add the following to your header:

    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/themes/overcast/jquery-ui.css" media="screen" rel="StyleSheet" type="text/css">  
    <link href="css/web_socket_file_uploader.css" media="screen" rel="StyleSheet" type="text/css">
    <script language="javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js" type="text/javascript"></script>
    <script language="javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js" type="text/javascript"></script>  
    <script language="javascript" src="js/web_socket_client.js" type="text/javascript"></script>
    <script language="javascript" src="js/web_socket_file_uploader.js" type="text/javascript"></script>
    <script language="javascript" src="js/application.js" type="text/javascript"></script>

Add the following block to the body of your web page:

    <div class="file_uploader">
      <h2>File Upload</h2>
      <div class="file_progress_bar">
        <span class="file_information" name="file_information"></span>
        <input class="file_browse_button" type="button" value="Browse">
        <input class="file_upload_button" type="button" value="Upload">
        <input class="file_reupload_button" type="button" value="Reupload">
        <input class="file_pause_button" type="button" value="Pause">
        <input class="file_resume_button" type="button" value="Resume">
        <input class="file_cancel_button" type="button" value="Cancel">
        <span class="file_progress" name="file_progress"></span>
        <input class="file_name_input" name="file_name_input" type="file">
      </div>
    </div>



Run the example on your server
------------------------------

An example HTTP Server (utilizing [Sinatra](http://sinatrarb.com)) and an example WebSocket Server (utilizing [em-websockets](http://github.com/igrigorik/em-websocket) are provided in this project. You can use these as templates or replace them with any other server of your choice.

Do this (or some variant)

    sudo apt-get install ruby rubygems
    gem install bundler
    git clone git://github.com/thirtysixthspan/waterunderice
    cd waterunderice
    bundle install
    ruby server.rb
    
Then visit your server on port 8000 (http://yourserver:8000).


Downsides
---------
* HTML 5 support is required of the browser.
* WebSockets currently only provides for ASCII transfers. Thus, files must be Base64 encoded prior to upload. This increases the total bytes transferred by one third and can load the CPU.


Browsers supporting WebSockets and FileReader
---------------------------------------------
* Chrome 4
* Firefox 4


License
-------
Copyright (c) 2010 Derrick Parkhurst (derrick.parkhurst@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

