/*Aashika Vachhani- C0903269
  Amisha Nakrani- C0903272
  Vohra Saifil- C0911452
  Jay Vara- C0908305*/
  
USE Eventbooking;

/*1.	Write a query that display order id or order no., customer_id , and customer address */

SELECT b.booking_id, c.first_name,c.last_name, c.city
FROM Booking b
	JOIN Customer c ON b.customer_id = c.customer_id;

/*2.	Write a query that display the product id or product number that have been NOT sold to any customer. */

SELECT t.event_ticket_id, t.name
FROM Event_Ticket t
	LEFT JOIN Booking_Has_Tickets b ON t.event_ticket_id = b.event_ticket_id
	WHERE b.event_ticket_id IS NULL;

/*3.	Write a query that display product information (productid, desc, cost, and another information of your choice) and it is related inventory or store if there is any.*/

SELECT event_ticket_id, name, description, sold_tickets, issued_tickets, begin_sale, end_sale
FROM Event_Ticket

/*4.	Write a query that display the list of customers/clients who made order and the list of the products in each order.*/

SELECT c.customer_id, c.first_name,c.last_name, b.booking_id, et.event_ticket_id, et.name
FROM Customer c
	JOIN Booking b ON c.customer_id = b.customer_id
	JOIN Booking_Has_Tickets bt ON b.booking_id = bt.booking_id
	JOIN Event_Ticket et ON bt.event_ticket_id = et.event_ticket_id;

/*5.	Write a query that display the list of customers/ clients who never made order.*/

SELECT c.customer_id, c.first_name, c.last_name
FROM Customer c
	LEFT JOIN Booking b ON c.customer_id = b.customer_id
	WHERE b.booking_id IS NULL;

/*6.	Write a query that display the list of products that never sold.*/

SELECT et.event_ticket_id, et.name
FROM Event_Ticket et
	LEFT JOIN Booking_Has_Tickets bt ON et.event_ticket_id = bt.event_ticket_id
	WHERE bt.booking_id IS NULL;

/*7.	Write a query that display the top customers (who made high purchase in total)*/
SELECT c.customer_id,c.first_name,c.last_name, SUM(et.price) AS total_purchase
FROM Customer c
	JOIN Booking b ON c.customer_id = b.customer_id
	JOIN Booking_Has_Tickets bt ON b.booking_id = bt.booking_id
	JOIN Event_Ticket et ON bt.event_ticket_id = et.event_ticket_id
	GROUP BY c.customer_id, c.first_name, c.last_name
	ORDER BY total_purchase DESC;

/*8.	Write a query that display the worst customers (who made low purchase in total or no purchase at all )*/
SELECT c.customer_id,c.first_name,c.last_name, SUM(et.price) AS total_purchase
FROM Customer c
	JOIN Booking b ON c.customer_id = b.customer_id
	JOIN Booking_Has_Tickets bt ON b.booking_id = bt.booking_id
	JOIN Event_Ticket et ON bt.event_ticket_id = et.event_ticket_id
	GROUP BY c.customer_id, c.first_name,  c.last_name
	ORDER BY total_purchase;