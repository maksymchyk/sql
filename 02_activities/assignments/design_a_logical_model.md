# Assignment 1: Maksym Parkhomchuk

 Design a Logical Model

## Question 1
Create a logical model for a small bookstore. 📚

At the minimum it should have employee, order, sales, customer, and book entities (tables). Determine sensible column and table design based on what you know about these concepts. Keep it simple, but work out sensible relationships to keep tables reasonably sized. Include a date table. There are several tools online you can use, I'd recommend [_Draw.io_](https://www.drawio.com/) or [_LucidChart_](https://www.lucidchart.com/pages/).

## Question 2
We want to create employee shifts, splitting up the day into morning and evening. Add this to the ERD.

## Question 3
The store wants to keep customer addresses. Propose two architectures for the CUSTOMER_ADDRESS table, one that will retain changes, and another that will overwrite. Which is type 1, which is type 2?

_Hint, search type 1 vs type 2 slowly changing dimensions._

Bonus: Are there privacy implications to this, why or why not?
```
Your answer...
```
Type 1 SCD is owerwriting addresses when a more recent address is entered. The customer_address table would include the following columns:

customer_id
address
city
province
postal_code
country

This approach would keep things more simple, store less data, have less privacy implications.

SCD type 2 is retaining changes. With every iteration of customer address the table would create a new record, while keeping historical records intact. Here is an example of what the table columns could look like in this case:

customer_id
address
city
province
postal_code
country
effective_date
expiry_date
validity

This would create more data and a larger table, also would add an ability to track history of address changes. However, there are privacy implications in this case. Customers need to be notified and give a consent to allow the company to keep and analyze their address change history records. Potentially, there could also be an ethical concerns of using address change history data for profiling customers. Old data shouldn't be stored for longer than it must be, and a necessity to keep historical records should be reviewed and discussed at least.

## Question 4
Review the AdventureWorks Schema [here](https://i.stack.imgur.com/LMu4W.gif)

Highlight at least two differences between it and your ERD. Would you change anything in yours?
```
Your answer...
```
My ERD shows a logical model of a database. It shows a scheme of tables and their columns, as well as describes types of relationships between them.

The AdventureWorks schema includes key types and uses the key types to showcase column relationships. In my opinion, it lacks a clear visual depiction of column relationships. It also misses description of column relationship types, which would add more context and clarity to the scheme.

My ERD shows exactly which column is related to which, but it lacks marking of primary and foreign keys.

Given that a lack of clarity in AdventureWorks schema could cause misinterpretation and confusion, I prefer my ERD. It showcases clear columns relationships and their types. On the other hand, a physical model would be more detailed. Including data types and key types would add more context to my ERD.

# Criteria

[Assignment Rubric](./assignment_rubric.md)

# Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `September 28, 2024`
* The branch name for your repo should be: `model-design`
* What to submit for this assignment:
    * This markdown (design_a_logical_model.md) should be populated.
    * Two Entity-Relationship Diagrams (preferably in a pdf, jpeg, png format).
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `model-design`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack at `#cohort-4-help`. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
