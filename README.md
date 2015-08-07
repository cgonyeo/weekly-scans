# Weekly Scans

This is a quick little [shelly](https://hackage.haskell.org/package/shelly)
Haskell program that uses nmap to scan predefined subnets, and record any hosts
it's unaware of.

This was written because I want to see what IP addresses the Computer Science
House has registered and not in use. I'll run it on a cronjob for a month or
two, and then follow up with the users who have registered IP addresses that are
unused.
