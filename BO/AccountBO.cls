public class AccountBO{
    
    private static AccountBO instance = new AccountBO();

    public static AccountBO getInstance(){
        return instance;
    }


    public static void atualizaContaEndereco(List<Account> acc){

         //### HISTORIA #####
    /* Crie uma Batch para preencher o endereço dos contatos de contas, com oendereço
     das contas(Fazer com que o endereço dos contatos sejao mesmo que os da contas que estão associados), porém
     essas contas a serem atualizadas devem ter no mínimo 2 contatos associados.
     */
        //# Adress Conta : BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,
        //# Adress Contato MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet
       
        List<Contact> attListContato = new List<Contact>();

      
        for(Account conta : acc){
            if(conta.Contacts.size() >=2){
               
                for(Contact c : conta.Contacts){
                    c.MailingCity = conta.BillingCity;
                    c.MailingCountry = conta.BillingCountry;
                    c.MailingPostalCode = conta.BillingPostalCode;
                    c.MailingState = conta.BillingState;
                    c.MailingStreet = conta.BillingStreet;
                    attListContato.add(c);
                }
            }
        }
        update attListContato;
    }  
}