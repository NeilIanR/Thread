# Thread
A lightweight utility for creating chainable tasks.

# How to use
- Require the script: local thread = require(path.to.thread)
- Create and start a thread: ```thread.new():spawn(function() end):start()```

# Example

```lua
local thread = require(path.to.thread)

thread:spawn(function()
    print("thread spawned")
end):wait(1):delay(4)
    print("5 seconds has passed")
end):start()
```
