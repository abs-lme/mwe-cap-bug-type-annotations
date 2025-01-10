namespace srv;

using { db } from '../db/schema';

service TestService {
    @odata.draft.enabled
    entity Test as select from db.Test;
}
