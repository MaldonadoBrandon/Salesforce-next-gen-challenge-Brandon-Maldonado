public class QuoteEmailHelper {
  
    public static void sendQuotePdfEmail(Id quoteId, Blob quoteBlob) {
        // Get the Quote and the Contact associated
        Quote quoteRecord = [SELECT Id, ContactId FROM Quote WHERE Id = :quoteId LIMIT 1];
        
        if (quoteRecord.ContactId != null) {
            Contact contact = [SELECT Id, Email, Name FROM Contact WHERE Id = :quoteRecord.ContactId LIMIT 1];
            
            if (contact != null && contact.Email != null) {
                // Prepare the email with the PDF attached
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { contact.Email });
                mail.setSubject('Your Quote PDF');
                mail.setPlainTextBody('Please find your quote attached.');
                
                // Attach the PDF
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('Cotizacion_' + contact.Name + '.pdf');
                attachment.setBody(quoteBlob);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
                
                // Send the email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}