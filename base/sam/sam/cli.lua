-- --- T2-COPYRIGHT-NOTE-BEGIN ---
-- This copyright note is auto-generated by ./scripts/Create-CopyPatch.
--
-- T2 SDE: package/.../sam/sam/cli.lua
-- Copyright (C) 2006 The T2 SDE Project
--
-- More information can be found in the files COPYING and README.
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; version 2 of the License. A copy of the
-- GNU General Public License can be found in the file COPYING.
-- --- T2-COPYRIGHT-NOTE-END ---

sam = sam or {}

--[[ DESCRIPTION ] ----------------------------------------------------------

Provided functions:

  cli = sam.cli(def)

    Define a CLI command set. The table "def" consist of key->function
	mappings, e.g. sam.cli { help = cli_cmd_help }. The return value is
	a CLI object with the following methods:

	cli:run()
	cli()

	  Start the event loop.

	cli:finish()

	  Leave the event loop.

	cli:send(...)

      Send a message (printf format). A trailing newline is appended
	  automatically.

	cli:get()

	  Used in the event loop: read (and tokenize) input

--]] ------------------------------------------------------------------------

require "sam.tokenize"

local __cli = {
	ok = true,
	command = {
		-- default wildcard command
		["*"] = function(self,cmd,...)
				self:send("[ERROR] unknown command: %s", cmd or "<none>")
			end,
		-- default "exit" command
		exit = function(self,...) self:finish() end,
	}
}

function __cli:finish()
	self.ok = false
end

function __cli:get()
	local line = io.stdin:read("*line")
	return sam.tokenize(line)
end

function __cli:send(...)
	io.stdout:write(string.format(unpack(arg)))
	io.stdout:write("\n")
end

function __cli:run()
	-- event loop
	while self.ok do
		-- wait for input
		local args = self:get()
		if not args then
			self.ok = false
			return
		end

		local cmd = args[1] ; table.remove(args, 1)

		-- check command
		if self.command[cmd] then
			self.command[cmd](self, unpack(args or {}))
		else
			self.command['*'](self, cmd, unpack(args or {}))
		end
	end
end

function sam.cli(def)
	local retval = __cli

	-- install commands
	for k,v in pairs(def) do
		sam.dbg("CLI", "Installing command '%s'\n", k)
		retval.command[k] = v
	end

	-- make retval executable
	setmetatable(retval, { __call = function(self) self:run() end })

	return retval
end

