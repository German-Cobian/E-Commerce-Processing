# Backend coding challenge

This is the coding challenge for people who applied to a backend developer position at SeQura. It's been designed to be a simplified version of the same problems we deal with.

## The challenge

SeQura provides ecommerce shops (merchants) a flexible payment method so their customers (shoppers) can purchase and receive goods without paying upfront. SeQura earns a small fee per purchase and pays out (disburse) the merchant once the order is marked as completed.
The operations manager is now asking you to make a system to calculate how much money should be disbursed to each merchant based on the following rules:
* Disbursements are done weekly on Monday.
* We disburse only orders which status is completed.
* The disbursed amount has the following fee per order:
  * 1% fee for amounts smaller than 50 €
  * 0.95% for amounts between 50€ - 300€
  * 0.85% for amounts over 300€
We expect you to:
* Create the necessary data structures and a way to persist them for the provided data. You don't have to follow our schema if you think another one suits better.
* Calculate and persist the disbursements per merchant on a given week. As the calculations can take some time it should be isolated and be able to run independently of a regular web request, for instance by running a background job.
* Create an API endpoint to expose the disbursements for a given merchant on a given week. If no merchant is provided return for all of them.
Find attached the merchants (https://www.dropbox.com/s/wms8dlqzs6bqkul/backend%20challenge%20dataset.zip?dl=0), shoppers and orders data on both json and csv files, use whatever it's easier for you. They follow this structure:

### MERCHANTS
```
ID | NAME                      | EMAIL                             | CIF
1  | Treutel, Schumm and Fadel | info@treutel-schumm-and-fadel.com | B611111111
2  | Windler and Sons          | info@windler-and-sons.com         | B611111112
3  | Mraz and Sons             | info@mraz-and-sons.com            | B611111113
4  | Cummerata LLC             | info@cummerata-llc.com            | B611111114
```
### SHOPPERS
```
ID | NAME                 | EMAIL                              | NIF
1  | Olive Thompson       | olive.thompson@not_gmail.com       | 411111111Z
2  | Virgen Anderson      | virgen.anderson@not_gmail.com      | 411111112Z
3  | Reagan Auer          | reagan.auer@not_gmail.com          | 411111113Z
4  | Shanelle Satterfield | shanelle.satterfield@not_gmail.com | 411111114Z
```
### ORDERS
```
ID | MERCHANT ID | SHOPPER ID | AMOUNT | CREATED AT           | COMPLETED AT
1  | 25          | 3351       | 61.74  | 01/01/2017 00:00:00  | 01/07/2017 14:24:01
2  | 13          | 2090       | 293.08 | 01/01/2017 12:00:00  | nil
3  | 18          | 2980       | 373.33 | 01/01/2017 16:00:00  | nil
4  | 10          | 3545       | 60.48  | 01/01/2017 18:00:00  | 01/08/2017 15:51:26
5  | 8           | 1683       | 213.97 | 01/01/2017 19:12:00  | 01/08/2017 14:12:43
```

## Instructions

* Please read carefully the challenge and if you have any doubt or need extra info please don't hesitate to ask us before starting.
* You shouldn't spend more than 3h on the challenge.
* Design, test, develop and document the code. It should be a performant, clean and well structured solution. Then send us a link or a zip with a git repo.
* You should consider this code ready for production as it were a PR to be reviewed by a colleague. Also commit as if it were a real assignment.
* Remember you're dealing with money, so you should be careful with related operations.
* Create a README explaining how to setup and run your solution and a short explanation of your technical choices, tradeoffs, ...
* You don't need to finish. We value quality over feature-completeness. If you have to leave things aside you can mention them on the README explaining why and how you would resolve them.
* You can code the solution in a language of your choice, here are some technologies we are more familiar with (no particular order): JavaScript, Ruby, Python, Go, Elixir, Java, Scala, PHP.
* Your experience level will be taken into consideration when evaluating.

# Solution

## Setup

From `Rails 6.0.1` and having `sqlite3 libsqlite3-dev` libraries execute:

```shell
bundle install
bundle exec rails db:setup
bundle exec rake disbursements:process
rails s
```
It can take a while because of seeds.

After all you will be allow to use the disbursements endpoint: 

```
curl -X GET -G 'http://localhost:3000/api/v1/disbursements' -d 'merchant_id=2323'
```

Allowed params:
* merchant_id :: Integer
* week :: Integer
* year :: Integer 


## Design

![imagen](./app/assets/E-commerce-graph.png)

In order to manage disbursements, I created `Disbursement` model.

It contains:
* merchant_id
* amount
* week
* year

It is also related with orders. In this way, we can get information about all the orders related with a disbursement. Additionaly, we can use it to know from `completed` orders, which of them are already processed (`not_disbursed` scope in `Order` model).

The hearth of this development is in `Disbursement.process` function.

Firstly, it iterates over merchants and try to create or find a new disbursement. In case of create a new one, year and week are set from current date.

In order to avoid edge cases where two processes tried to create a new disbursement, `merchant_id`, `year` and `week` have a unique index and in this case an exception will be thrown and `retry` will be performed (and finally the record will be found).

Once I have the disbursement record, I iterate in batches across orders, filtering by each merchant and returning completed and not disbursed orders.

After that, I use a transaction to calculate and update the disbursement amount and mark all orders as part of this disbursement. This transaction allows us to be sure that an order won't be processed twice (at least in a not distributed database).

To calculate the fees, I've included a method `net_amount` in `Order` model that permit us to know the final disbursement for this orderd. This method is called when I'm iterating in batches in the reduce function to calculate the total sum:

```ruby
amount = orders.reduce(disbursement.amount) { |current_amount, order| current_amount + order.net_amount }
```

Also, I decided to use decimal instead of floats type to have more precission since, I don't know how decimals are treated in real cases.

Finally, I created the api endpoint and I used an scope in routes to versioning the api for future changes.

## Improvements

I've spent about 3 - 4 hours in that challenge. But there are so many things to be improved:

### Cache

Since disbursements rarely will change, we could implement a cache at server level to avoid requests overload our application.

### Crontab

As the requirements of the challenge say, we should add the rake task to the crontab to be performed all mondays (or sundays maybe?)

### Log

A system to log the merchants processed would be a nice idea to be able to debug or be sure things are ok in production.

### API auth

As simple as add a token and check it in every API request could be a simple and fast solution.

### Testing

Adding gems like `factory_bot`

### CI

Integrate CI in repository to automate things like rubocop, test coverage checks and tests passing
