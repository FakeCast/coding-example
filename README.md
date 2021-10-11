# Holidays Plan API
I designed an API to controll the holidays plan.

I spent more or less 4 hours on this project.
I implemented the Vacation Request creation/listing/approving/rejecting.
What is missing?
 - Worker request listing
 - Worker remaining vacation days
 - Manager list by worker
 - Manager list of overlaping vacations
 - More edge cases tests
 - Friendly error messages


 I didn't implement any authorization/authentication process, but I was thinking about generating a token for managers/workers and this way we can define the access rights.



## Technologies:
  - Ruby 2.6.6
  - Rails 6.1.4
  - MySQL
## Gems
  - RSpec
  - FactoryBot
  - ActiveModel serializers
---
## How to run
  clone the repo
  run
  ```ruby
    bundle install
    rake db:create db:migrate db:seed
    rails s
  ```
---
## How to test
`bundle exec rspec`

---

## API Docs
I could use Swager to document the API docs, but since is just a few endpoints I am going to add it to the README file

---

**List Vacation Requests**

Return the list of vacation requests

* **URL**

  /api/v1/vacation_request

* **Method:**

  `GET`

*  **URL Params**

    **Optional:**

      `status=approved/rejected/pending`

 * **Success Response:**

  * **Code:** 200 <br />
    **Content:**

```
  [
    {
      "id": 2,
      "author": 1,
      "status": "pending",
      "resolved_by": null,
      "request_created_at": "2021-10-10T11:51:22.730Z",
      "vacation_start_date": "2021-11-20T00:00:00.000+00:00",
      "vacation_end_date": "2021-11-20T00:00:00.000+00:00"
    }
  ]
```

---
**Show Vacation Requests**

Show specific vacation request data

* **URL**

  /api/v1/vacation_request/:id

* **Method:**

  `GET`

*  **URL Params**

    **Optional:**

    `id=[integer]`

 * **Success Response:**

  * **Code:** 200 <br />
    **Content:**
```
  {
    "id": 4,
    "author": 1,
    "status": "approved",
    "resolved_by": 2,
    "request_created_at": "2021-10-10T11:52:22.842Z",
    "vacation_start_date": "2021-11-20T00:00:00.000+00:00",
    "vacation_end_date": "2021-11-20T00:00:00.000+00:00"
  }
```

---
**Create Vacation Requests**

Show specific vacation request data

* **URL**

  /api/v1/vacation_request/

* **Method:**

  `POST`

* **Data Params**

  `worker_id=[integer]`

  `vacation_start_date=[date] //2021-11-10`

  `vacation_end_date=[date] //2021-11-11`
 * **Success Response:**

  * **Code:** 201 <br />
    **Content:**
```
  {
    "id": 7,
    "author": 1,
    "status": "pending",
    "resolved_by": null,
    "request_created_at": "2021-10-11T10:38:24.945Z",
    "vacation_start_date": "2021-11-08T00:00:00.000+00:00",
    "vacation_end_date": "2021-11-08T00:00:00.000+00:00"
  }
```
---

**Approve Vacation Request**

Show specific vacation request data

* **URL**

  /api/v1/vacation_request/:id/approve

* **Method:**

  `PUT`

* **Data Params**

  `resolved_by_id=[integer] // Must be a manager`
 * **Success Response:**

  * **Code:** 200 <br />
    **Content:**
```
  {
    "id": 4,
    "author": 1,
    "status": "approved",
    "resolved_by": 2,
    "request_created_at": "2021-10-10T11:52:22.842Z",
    "vacation_start_date": "2021-11-20T00:00:00.000+00:00",
    "vacation_end_date": "2021-11-20T00:00:00.000+00:00"
  }
```

---
**Reject Vacation Request**

Show specific vacation request data

* **URL**

  /api/v1/vacation_request/:id/reject

* **Method:**

  `PUT`

* **Data Params**

  `resolved_by_id=[integer] // Must be a manager`
 * **Success Response:**

  * **Code:** 200 <br />
    **Content:**
```
  {
    "id": 4,
    "author": 1,
    "status": "rejected",
    "resolved_by": 2,
    "request_created_at": "2021-10-10T11:52:22.842Z",
    "vacation_start_date": "2021-11-20T00:00:00.000+00:00",
    "vacation_end_date": "2021-11-20T00:00:00.000+00:00"
  }
```