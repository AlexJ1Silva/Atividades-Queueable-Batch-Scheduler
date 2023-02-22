public with sharing class OpportunityBO{
    private static OpportunityBO instance = new OpportunityBO();
    public static OpportunityBO getInstance(){
        return instance;
    }

    public static void criaContratoOpp(){

        //####HISTORIA######
        /* Crie um Schudule que busque todas as oportunidades
         que estão com Estágio em “Close Won” ou com a quantia da oportunidade acima de 100 mil reais
         e crie um contrato para essa oportunidade, use a mesma Conta da oportunidade para criar o Contrato. */

        List<Contract> contractList = new List<Contract>();
        List<Opportunity> opptList = OpportunityDAO.getOpportunityIdList();

        for (Opportunity opp : opptList){
            Contract c = new Contract();
            c.AccountId = opp.AccountId;
            c.Status = 'In Approval Process';
            c.StartDate = system.today();
            c.ContractTerm = 12;
            c.Opportunity__c = opp.Id;
            contractList.add(c);
        }

        Database.insert (contractList);


        List<Opportunity> attOppList = new List<Opportunity>();

        for (Contract c : contractList){
            Opportunity opp = new Opportunity();
            opp.id = c.Opportunity__c;
            opp.ContractId = c.Id;
            attOppList.add(opp);
        }

        Database.update (attOppList);
    }

    public static void attOppSemContato(List<Opportunity> oppList){

        //###HISTORIA###
        /* Crie uma  Queueable que receba uma lista de Oportunidades e verifique se alguma dessas oportunidades
         não possuem contato, após atualizar essas oportunidades sem contato,
         associando ao primeiro Contato encontrado associado à Conta que está na Oportunidade. */

        List<Opportunity> attOppList = new List<Opportunity>();

        Set<Id> accountId = new Set<Id>();

        Map<Id, Account> mapAcc = new Map<Id, Account>();

        for (Opportunity opp : oppList){
            if (opp.ContactId == null){
                attOppList.add(opp);
                accountId.add(opp.AccountId);
            }
        }

        List<Account> listAcc = AccountDAO.getAccountContactsById(accountId);

        for (Account a : listAcc){
            mapAcc.put(a.id, a);
        }

        for (Opportunity opp : attOppList){
            Account a = mapAcc.get(opp.AccountId);
            if (a.Contacts.size() > 0){
                opp.ContactId = a.Contacts[0].Id;
            }
        }

        update attOppList;
    }

    public static List<Opportunity> attDescricao(){
        //####HISTORIA####
        /* Crie uma Queueable que busque oportunidades com a Data de Fechamento maior que a data atual,
         e atualize o campo Descrição para “Oportunidades com contato associado”.
         Após isso chame a Queable criada na atividade anterior passando para ela a lista de oportunidade buscadas.
         (Isso fará o encadeamento de duas Queueables). */
        List<Opportunity> listOpp = OpportunityDAO.getOppoDataFechamentoList();

        for (Opportunity opp : listOpp){
            opp.Description = 'Oportunidades com contato associado';
        }
        return listOpp;
    }

}