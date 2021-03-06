<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry.

    FarCry is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with FarCry.  If not, see <http://www.gnu.org/licenses/>.
--->
<!---
|| VERSION CONTROL ||
$Header: /cvs/farcry/core/tags/farcry/_requestScope.cfm,v 1.5 2005/08/09 03:54:39 geoff Exp $
$Author: geoff $
$Date: 2005/08/09 03:54:39 $
$Name: milestone_3-0-1 $
$Revision: 1.5 $

|| DESCRIPTION || 
$Description: initialise request scope $


|| DEVELOPER ||
$Developer: Brendan Sisson (brendan@daemon.com.au)$

|| ATTRIBUTES ||
$in: $
$out:$
--->

<cfsetting enablecfoutputonly="Yes">

<!--------------------------------------------------------------------
site design parameters 
These appear to have been completely removed from this implementation.
We need at least the following parameters:
designmode // container management flag
flushcache // reset content caches on page
showdraft
	// resulting in determination of..
	request.lValidStatus
showtables // style sheet change to highlight table borders
showerror // bypass friendly error page
showdebugoutput // show debugoutput in full (default is suppressed)

TODO:
 - implement parameters
 - check security for access to parameters
 - rebuild floater menu
--------------------------------------------------------------------->
<cfparam name="request.fc" default="#structnew()#" />
<cfscript>
// init request.fc vars
request.fc.bShowTray = true;


// init request.mode with defaults
request.mode = structNew();
request.mode.design = 0;
request.mode.flushcache = 0;
request.mode.showdraft = 0;

// Developer Mode
request.mode.bDeveloper = 0;

// container management
// default to off, conjurer determines permissions based on nav-node
request.mode.showcontainers = 0; 

// TODO other options to be added
request.mode.showtables = 0;
request.mode.showerror = 0;
request.mode.showdebugoutput = 0;

// admin options visible in page
if (IsDefined("session.dmSec.Authentication.bAdmin")) {
	request.mode.bAdmin = session.dmSec.Authentication.bAdmin; 
} else {
	request.mode.bAdmin = 0; // default to off
}


	
// if user has admin priveleges, determine mode values
if (request.mode.bAdmin) {
// designmode
	if (isDefined("url.designmode")) {
		request.mode.design = val(url.designmode);
		session.dmSec.Authentication.designmode = request.mode.design;
	} else if (isDefined("session.dmSec.Authentication.designmode")) {
		request.mode.design = session.dmSec.Authentication.designmode;
	} else {
		request.mode.design = 0;
	}

// bypass caching
	if (isDefined("url.flushcache")) {
		request.mode.flushcache = val(url.flushcache);
		session.dmSec.Authentication.flushcache = request.mode.flushcache;
	} else if (isDefined("session.dmSec.Authentication.flushcache")) {
		request.mode.flushcache = session.dmSec.Authentication.flushcache;
	} else {
		request.mode.flushcache = 0;
	}

// view content as stage
	if (isDefined("url.showdraft")) {
		request.mode.showdraft = val(url.showdraft);
		session.dmSec.Authentication.showdraft = request.mode.showdraft;
	} else if (isDefined("session.dmSec.Authentication.showdraft")) {
		request.mode.showdraft = session.dmSec.Authentication.showdraft;
	} else {
		request.mode.showdraft = 0;
	}

}

// set valid status for content
if (request.mode.showdraft) {
	request.mode.lValidStatus = "draft,pending,approved";
} else {
	request.mode.lValidStatus = "approved";
}

// Deprecated variables
// TODO remove these when possible
request.lValidStatus = request.mode.lValidStatus; //deprecated
</cfscript>

<cfsetting enablecfoutputonly="no">