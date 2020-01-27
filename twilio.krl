ruleset io.picolabs.use_twilio_v2 {
  meta {
    use module io.picolabs.lesson_keys
    use module io.picolabs.twilio_v2 alias twilio
        with account_sid = keys:twilio{"account_sid"}
             auth_token =  keys:twilio{"auth_token"}
	
	shares __testing
  }

  global {
	  __testing = { 
	  	"queries": [],
		"events": [ 
			{ "domain": "test", "type": "messages" },
			{ "domain": "test", "type": "messages", "attrs": [ "from" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "to" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "page" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "page_size" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "from", "to" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "page", "page_size" ] },
			{ "domain": "test", "type": "messages", "attrs": [ "from", "to", "page", "page_size" ] }
		]
	  }
  }

  rule test_send_sms {
    select when test new_message
    twilio:send_sms(event:attr("to"),
                    event:attr("from"),
                    event:attr("message")
                   )
  }

  rule get_messsages {
  	select when test messages

	pre {
		response = twilio:messages(event:attr("page_size"),
						event:attr("page"),
						event:attr("to"),
						event:attr("from")
						)
	}

	send_directive("twilio_response", response)
  }
  
}
