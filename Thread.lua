export type Thread<T> = {
	ClassName: "Thread";
	
	spawn: (self: Thread<T>, callback: (... any) -> (), ... any) -> Thread<T>;
	
	wait: (self: Thread<T>, duration: number) -> Thread<T>;
	delay: (self: Thread<T>, duration: number, callback: () -> ()) -> Thread<T>;
	
	start: (self: Thread<T>) -> Thread<T>;
};

type _Thread<T> = Thread<T> & {
	_queue: { () -> () };
};

local Thread = {};
local mt = { __index = Thread };

function Thread.new<T>(): _Thread<T>
	local self = setmetatable({
		
		_queue = {};
		
	}, mt) :: _Thread<T>;
	
	return self;
end

function Thread:spawn<T>(callback: () -> (), ...: any): _Thread<T>
	local args = { ... };
	
	table.insert(self._queue, function()
		task.spawn(callback, table.unpack(args))
	end)
	
	return self;
end

function Thread:wait<T>(duration: number): _Thread<T>
	table.insert(self._queue, function()
		task.wait(duration)
	end)
	
	return self;
end

function Thread:delay<T>(duration: number, callback: () -> ()): _Thread<T>
	table.insert(self._queue, function()
		task.delay(duration, callback)
	end)
	
	return self;
end

function Thread:start<T>(): _Thread<T>
	coroutine.wrap(function()
		for _, step in ipairs(self._queue) do
			step()
		end
	end)()
	
	return self;
end


return Thread;
