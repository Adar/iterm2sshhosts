#!/usr/bin/osascript

on run (arguments)
	try
		set configFile to POSIX file (first item of arguments)
	on error
		error "Need configFile as first argument"
	end try
	
	tell application "iTerm"
		
		try
			set listOfHosts to {}
			set hostLines to paragraphs of (read file configFile)
			repeat with nextLine in hostLines
				if length of nextLine is greater than 0 then
					copy nextLine to the end of listOfHosts
				end if
			end repeat
		on error
			error (first item of arguments) & " konnte nicht geöffnet werden oder ist leer"
		end try
		
		set newWindow to (create window with default profile)
		set session1 to current session of newWindow
		
		-- split needed
		if ((count of listOfHosts) is greater than 1) then
			
			-- first split vertically
			set session2 to (split vertically with default profile session1)
			set i to 1
			
			-- split for n hosts
			repeat with hostName in listOfHosts
				-- split session1 and session2
				set newSession to session1
				if (i is 2) then
					set newSession to session2
				else if (i is greater than 2) then
					-- begin with 3rd host
					if (i mod 2 is 1) then
						set newSession to (split horizontally with default profile session1)
					else
						set newSession to (split horizontally with default profile session2)
					end if
				end if
				
				tell newSession
					write text "ssh  " & hostName
				end tell
				set i to i + 1
			end repeat
		else
			-- only one host, no split needed
			repeat with hostName in listOfHosts
				tell session1
					write text "ssh " & hostName
				end tell
			end repeat
		end if
	end tell
	
end run

