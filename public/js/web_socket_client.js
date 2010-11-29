
function WebSocketClient(host)
{
  
  // Initialize

  var wsc = this;


  // Public

  this.initialize = function(data) 
  {
    if (!supported()) return false;
    if (!connect()) return false;
    return true;
  }

  this.send = function(data) 
  {
	  if (wsc.socket.readyState!=1) {
      wsc.socket.close();
		  return false;
    }

    try {
      wsc.socket.send(data);
    } catch (exception) {
      wsc.socket.close();
      return false;
    }
    return true;
  }

  this.close = function()
  {
    wsc.socket.close();
  }

  // Privaleged 

  function supported()
  {
    if (!("WebSocket" in window)) return false;
    return true;
  }

  function connect()
  {
    try {
      wsc.socket = new WebSocket(host);
 
      wsc.socket.onopen = function()
      {
        // to be overridden
      }

      wsc.socket.onmessage = function(message) 
      { 
        // to be overridden
      }

      wsc.socket.onclose = function()
      {
        // to be overridden
      }      
    } catch(exception) {
      return false;
    }

    return true;
  }

}



