EmailService-cfc
================

This is a CF service for sending email.

The service optionally performs email logging to a database if you provide the datasource argument.

You can also hook into an email templates system if you have one. I did not provide one for the initial release.

As of the initial release, email attachments are unsupported even though there are arguments for them.

Supported email attributes include:
* ReplyTo address
* From name
* From address
* To address
* CC address
* BCC address
* Subject
* Body (html format)
* Body (plain text format)
* Mode (i.e., live, test)

This project includes a sample caller file: emailservicetester.cfm
