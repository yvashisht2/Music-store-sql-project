-- Q 1) Who is the senior most employee based on job title?
select * from employee order by levels desc limit 1;

-- Q2) which countries have the most invoices?
select count(*) as c,billing_country from invoice 
group by billing_country order by c desc;

-- Q3) What are top 3 values of total invoice?
select * from invoice order by total desc limit 3 ;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select sum(total) as c, billing_city from invoice 
group by billing_city order by c desc limit 1;


/* Q5: Who is the best customer? The customer who has spent the most
money will be declared the best customer. Write a query that returns
the person who has spent the most money.*/

select sum(invoice.total)as total_sum,customer.first_name,
customer.last_name ,customer.customer_id  from invoice inner join 
customer on customer.customer_id=invoice.customer_id  group by customer.customer_id order by total_sum desc limit 1 ;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select distinct customer.first_name,customer.last_name,customer.email,genre.name  from genre inner join track on genre.genre_id=track.genre_id inner join invoice_line on track.track_id=invoice_line.track_id inner join invoice on invoice_line.invoice_id=invoice.invoice_id inner join customer on customer.customer_id=invoice.customer_id  where genre.genre_id='1'  order by email ;



/* Q2: Let's invite the artists who have written the most rock 
music in our dataset. Write a query that returns the Artist name 
and total track count of the top 10 rock bands. */

select count(artist.artist_id) as c, artist.artist_id,artist.name from artist inner join album on artist.artist_id=album.artist_id inner join track on track.album_id=album.album_id inner join genre on genre.genre_id=track.genre_id  where genre.name='Rock' group by artist.artist_id order by c desc;


/* Q3: Return all the track names that have a song length longer than
the average song length. Return the Name and Milliseconds for each
track. Order by the song length with the longest songs listed first. */
select name, milliseconds from track where milliseconds >( select avg(milliseconds) from track) order by milliseconds desc;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write
a query to return customer name, artist name and total spent */

select customer.first_name , customer.last_name,artist.name,sum(invoice_line.unit_price*invoice_line.quantity) as total_sum from customer inner join invoice on customer.customer_id=invoice.customer_id inner join invoice_line on invoice.invoice_id=invoice_line.invoice_id inner join track on invoice_line.track_id=track.track_id inner join album on track.album_id=album.album_id inner join artist on artist.artist_id=album.artist_id group by customer.customer_id,artist.name order by total_sum desc;


/* Q2: We want to find out the most popular music Genre for each
country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns 
each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
with popular_genre as(
select invoice.billing_country ,genre.name,sum(invoice_line.quantity) as s,ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo  from invoice inner join invoice_line on invoice.invoice_id=invoice_line.invoice_id inner join track on invoice_line.track_id=track.track_id inner join genre on genre.genre_id=track.genre_id group by invoice.billing_country,genre.name  order by invoice.billing_country asc , s desc )
select * from popular_genre where RowNo <=1;


/* Q3: Write a query that determines the customer that has spent the
most on music for each country. Write a query that returns the 
country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all 
customers who spent this amount. */
with max_customer as(
select concat(customer.first_name,' ',customer.last_name) as Full_name,invoice.billing_country,sum(invoice.total) as t,ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY COUNT(invoice.total) DESC) AS RowNo  from customer inner join invoice on invoice.customer_id=customer.customer_id group by invoice.billing_country, customer.customer_id order by invoice.billing_country asc, t desc)
select * from max_customer where RowNo <=1;