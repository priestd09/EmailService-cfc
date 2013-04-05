<cfcomponent name="EmailService" displayname="Email Service" output="false" hint="Generic Service object. I also provide functions for sending email.">

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component">
		<cfargument name="datasource" type="string" required="false" default="" hint="I am the datasource.">
		<cfargument name="dao" type="string" required="false" default="EmailDAO" hint="I am the dao.">
		<cfargument name="gateway" type="string" required="false" default="EmailGateway" hint="I am the gateway.">
		<cfscript>
			variables.datasource = arguments.datasource;
			variables.dao = createObject("component",arguments.dao).init(datasource=variables.datasource);
			variables.gateway = createObject("component",arguments.gateway).init(datasource=variables.datasource);
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="sendEmail" access="public" output="false" returntype="boolean" hint="I send the email.">
		<cfargument name="emailtemplateid" type="numeric" required="false" default="0" hint="I am the email template id to use for getting the properties of the email. This is currently unsupported." />
		<cfargument name="templatecode" type="string" required="false" default="" hint="I am the template code to filter email template results." />
		<cfargument name="emailfromid" type="string" required="false" default="" hint="I am the ID of the email sender.">
		<cfargument name="emailrecipientid" type="string" required="false" default="" hint="I am the ID of the email recipient.">
		<cfargument name="emailreplytoaddress" type="string" required="false" default="" hint="I am the email address for which to reply." />
		<cfargument name="emailfromname" type="string" required="false" default="" hint="I am the name of the reply to email address." />
		<cfargument name="emailfromaddress" type="string" required="false" default="" hint="I am the email address sending the email." />
		<cfargument name="emailtoaddress" type="string" required="false" default="" hint="I am the 'to' email recipient." />
		<cfargument name="emailccaddress" type="string" required="false" default="" hint="I am the 'cc' email recipient." />
		<cfargument name="emailbccaddress" type="string" required="false" default="" hint="I am the 'bcc' email recipient." />
		<cfargument name="emailsubject" type="string" required="false" default="" hint="I am the subject of the email." />
		<cfargument name="emailbodyhtml" type="string" required="false" default="" hint="I am the HTML version of the email body." />
		<cfargument name="emailbodyplaintext" type="string" required="false" default="" hint="I am the plain text version of the email body." />
		<cfargument name="emailattachmentid" type="numeric" required="false" default="0" hint="I am the email attachment id to use for getting the properties of the email attachment. This is currently unsupported." />
		<cfargument name="emailattachmentname" type="string" required="false" default="" hint="I am the name/title of the email attachment used for display purposes." />
		<cfargument name="emailattachmentsourcefile" type="string" required="false" default="" hint="I am the full path of the email attachment source file." />
		<cfargument name="emailattachmentfilename" type="string" required="false" default="" hintlt="I am the file name to use for the email attachment to give it context." />
		<cfargument name="mode" type="string" required="false" default="live" hint="I determine if the email is live or a test.">
		
		<cfset var local = {}>

		<cftry>
			<cfscript>
				if (StructKeyExists(arguments,"emailtemplateid") AND IsNumeric(arguments.emailtemplateid) AND arguments.emailtemplateid NEQ 0 AND 1 EQ 2) {
					// set email properties; currently unsupported
				}
				else {
					local.emailobject.emailtemplateid = arguments.emailtemplateid;
					local.emailobject.templatecode = arguments.templatecode;
					local.emailobject.emailfromid = arguments.emailfromid;
					local.emailobject.emailrecipientid = arguments.emailrecipientid;
					local.emailobject.emailreplytoaddress = arguments.emailreplytoaddress;
					local.emailobject.emailfromname = arguments.emailfromname;
					local.emailobject.emailfromaddress = arguments.emailfromaddress;
					local.emailobject.emailtoaddress = arguments.emailtoaddress;
					local.emailobject.emailccaddress = arguments.emailccaddress;
					local.emailobject.emailbccaddress = arguments.emailbccaddress;
					local.emailobject.emailsubject = arguments.emailsubject;
					if (len(local.emailobject.emailsubject) GT 73) {
						local.emailobject.emailsubject = Left(local.emailobject.emailsubject,70) & "...";
					}
					local.emailobject.emailbodyhtml = arguments.emailbodyhtml;
					local.emailobject.emailbodyplaintext = arguments.emailbodyplaintext;
					local.emailobject.emailattachmentid = arguments.emailattachmentid;
					local.emailobject.emailattachmentname = arguments.emailattachmentname;
					local.emailobject.emailattachmentsourcefile = arguments.emailattachmentsourcefile;
					local.emailobject.emailattachmentfilename = arguments.emailattachmentfilename;
					local.emailobject.mode = arguments.mode;
				}

				if
				(
					(NOT len(trim(local.emailobject.emailbodyhtml)) AND NOT len(trim(local.emailobject.emailbodyplaintext)))
					OR NOT len(trim(local.emailobject.emailsubject))
					OR validateEmailAddress(sourceEmailAddress=local.emailobject.emailreplytoaddress) IS "invalid"
					OR validateEmailAddress(sourceEmailAddress=local.emailobject.emailfromaddress,onlyAllowOneAddress=true) IS "invalid"
					OR validateEmailAddress(sourceEmailAddress=local.emailobject.emailtoaddress) IS "invalid"
					OR validateEmailAddress(sourceEmailAddress=local.emailobject.emailccaddress) IS "invalid"
					OR validateEmailAddress(sourceEmailAddress=local.emailobject.emailbccaddress) IS "invalid"
				)
				{
					return false;
				}
			</cfscript>

			<cfif len(trim(local.emailobject.emailattachmentsourcefile))>
				<cfloop list="#local.emailobject.emailattachmentsourcefile#" index="local.emailobject.emailattachmentsourcefileindex">
					<cfif NOT FileExists(local.emailobject.emailattachmentsourcefileindex)>
						<cfreturn false>
					</cfif>
				</cfloop>
			</cfif>

			<cfset local.emailobject.emailfrom = local.emailobject.emailfromaddress>
			<cfif len(trim(local.emailobject.emailfromname))>
				<cfset local.emailobject.emailfrom = '#local.emailobject.emailfromname# <#local.emailobject.emailfromaddress#>'>
			</cfif>

			<cfmail from="#local.emailobject.emailfrom#" replyto="#local.emailobject.emailreplytoaddress#" to="#local.emailobject.emailtoaddress#" cc="#local.emailobject.emailccaddress#" bcc="#local.emailobject.emailbccaddress#" subject="#local.emailobject.emailsubject#">
				<cfif len(trim(local.emailobject.emailbodyplaintext))>
					<cfset local.emailobject.emailbodyplaintext = fixFCKEditorCode(inputString=local.emailobject.emailbodyplaintext)>
					<cfmailpart type="text">#local.emailobject.emailbodyplaintext#</cfmailpart>
				</cfif>
				<cfif len(trim(local.emailobject.emailbodyhtml))>
					<cfset local.emailobject.emailbodyhtml = fixFCKEditorCode(inputString=local.emailobject.emailbodyhtml)>
					<cfmailpart type="html">#local.emailobject.emailbodyhtml#</cfmailpart>
				</cfif>
			</cfmail>

			<!--- fire and forget log --->
			<cftry>
				<cfif len(trim(variables.datasource))>
					<cfset local.objEmailLogService = new EmailLogService(datasource=variables.datasource)>
					<cfset local.objEmailLogService.logEmail(argumentCollection=local.emailobject)>
				</cfif>
				<cfcatch type="any">
				</cfcatch>
			</cftry>

			<cfreturn true>
			<cfcatch type="any">
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="fixFCKEditorCode" access="public" output="false" returntype="string" hint="I replace double http://'s with single ones">
		<cfargument name="inputString" type="string" required="true" />

		<cfset var local = {}>

		<cfset local.outputString = arguments.inputString>

		<!--- fix the HyperLink tags --->
		<cfset local.replaceHyperLinks = 'http://,https://,ftp://,news://'>
		<cfloop list='#local.replaceHyperLinks#' index="local.i">
			<cfloop list='#local.replaceHyperLinks#' index="local.j">
				<cfset local.outputString = replacenocase(local.outputString,'#local.i##local.j#','#local.j#','all')>
			</cfloop>
		</cfloop>

		<cfreturn local.outputString>
	</cffunction>

	<cffunction name="validateEmailAddress" access="public" output="false" returntype="string" hint="I validate and clean up an email address or multiple email addresses">
		<cfargument name="sourceEmailAddress" type="string" required="true" />
		<cfargument name="stripInvalidAddresses" type="boolean" required="false" default="true" />
		<cfargument name="onlyAllowOneAddress" type="boolean" required="false" default="false" />

		<cfset var local = {}>

		<cfset local.error = false>
		<cfset local.outputEmailAddresses = ''>

		<cftry>
			<cfif StructKeyExists(arguments,"sourceEmailAddress") AND NOT len(trim(arguments.sourceEmailAddress))>
				<cfreturn arguments.sourceEmailAddress>
			</cfif>
			<!--- First lets try to clean up the data with a series of replacements --->
			<cfscript>
				local.processEmailAddresses = trim(arguments.sourceEmailAddress);
				local.processEmailAddresses = replacenocase(local.processEmailAddresses,', ',',','all');
				local.processEmailAddresses = replacenocase(replacenocase(local.processEmailAddresses,'; ',',','all'),';',',','all');
				local.processEmailAddresses = replacenocase(replacenocase(local.processEmailAddresses,'| ',',','all'),'|',',','all');
				local.processEmailAddresses = replacenocase(replacenocase(local.processEmailAddresses,': ',',','all'),':',',','all');
				local.processEmailAddresses = replacenocase(replacenocase(local.processEmailAddresses,'  ',',','all'),' ',',','all');
			</cfscript>
			<!--- Now the string should be clean we can loop through, do a little more cleaning and validate each email address --->
			<cfloop list="#local.processEmailAddresses#" index="local.thisEmailAddress">
				<cfif len(trim(local.thisEmailAddress))>
					<cfif isvalid("email",trim(local.thisEmailAddress))>
						<cfset local.outputEmailAddresses = listappend(local.outputEmailAddresses,trim(local.thisEmailAddress))>
					<cfelse>
						<cfif NOT arguments.stripInvalidAddresses>
							<!--- Invalid Email Address detected, break out of loop and return --->
							<cfset local.error = true>
							<cfbreak>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			<cfcatch>
				<cfset local.error = true>
			</cfcatch>
		</cftry>

		<cfif NOT local.error AND len(trim(local.outputEmailAddresses)) AND (NOT arguments.onlyAllowOneAddress OR (arguments.onlyAllowOneAddress AND listlen(local.outputEmailAddresses) EQ 1))>
			<cfreturn local.outputEmailAddresses>
		<cfelse>
			<cfreturn 'invalid'>
		</cfif>
	</cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">
		<cfargument name="missingMethodName" type="string">
	    <cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>