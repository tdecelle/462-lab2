ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello
  }
   
  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }
  }
   
  rule hello_world {
    select when echo hello
    send_directive("say", {"something": "Hello World"})
  }

  rule hello_monkey {
    select when echo monkey

    pre {
      name = (event:attr("name").defaultsTo("Monkey")).klog("Name: ").head()
    }

    send_directive("say", {"something": "Hello " + name})
  }

  rule hello_monkey2 {
    select when echo monkey
     pre {
       name = event:attr("name").isnull() => ("Monkey") | event:attr("name")
	   name.klog("Name: ").head()
     }

     send_directive("say", {"something": "Hello " + name})
  }
   
}
