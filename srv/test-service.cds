namespace srv;

using { db } from '../db/schema';

service TestService {
    entity Test as select from db.Test;
}
