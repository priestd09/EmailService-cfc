<cfscript>
	variables.objEmailService = new EmailService();

	variables.emailobject = {};
	variables.emailobject.emailreplytoaddress = "replytome@domain.com";
	variables.emailobject.emailfromname = "John Doe";
	variables.emailobject.emailfromaddress = "noreply@domain.com";
	variables.emailobject.emailtoaddress = "to@domain.com";
	variables.emailobject.emailccaddress = "cc@domain.com";
	variables.emailobject.emailbccaddress = "bcc@domain.com";
	variables.emailobject.emailsubject = "email service test";
	variables.emailobject.emailbodyhtml = "<em>this is just a test</em>";
	variables.emailobject.emailbodyplaintext = "this is just a test";
	variables.emailobject.mode = "test";

	variables.emailresult = variables.objEmailService.sendEmail(argumentCollection=variables.emailobject);

	writeOutput("Result = #variables.emailresult#");
</cfscript>