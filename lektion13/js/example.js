// connect to mongo db server
// localhost and standard port
const conn = new Mongo()

// authenticate against admin db
const adminDb = conn.getDB("admin")
// for newer version of mongo shell you can
// omit the second argument
adminDb.auth("mongoadmin", "yrgoP4ssword")

// connect to actual database
// your permissions will remain
let db = conn.getDB("scdb")
db.createCollection("people")

db.people.drop()

let names = [ "Anna Andersson", "Bosse Bengtsson", "Cecilia Cederholm" ]
for (const name of names) {
    db.people.insertOne({
        name,
        age: Math.floor(Math.random()*30 + 30),
    })
}

const people = db.people.find({ age: { $gt: 40 } })
while (people.hasNext()) {
    const person = people.next()
    print(person.name)
}
