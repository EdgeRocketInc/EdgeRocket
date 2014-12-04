SELECT name
FROM products
WHERE 
to_tsvector(coalesce(name,'')||coalesce(description,'')||coalesce(authors,'')||coalesce(keywords,'')||coalesce(school,'')) 
@@ to_tsquery('research');


SELECT name
FROM products
WHERE 
to_tsvector(coalesce(name,'')||' '
	||coalesce(description,'')||' '
	||coalesce(authors,'')||' '
	||coalesce(keywords,'')||' '
	||coalesce(school,'')) 
@@ plainto_tsquery('research');

CREATE INDEX products_full_idx ON products USING gin(
to_tsvector('english',coalesce(name,'')||' '
	||coalesce(description,'')||' '
	||coalesce(authors,'')||' '
	||coalesce(keywords,'')||' '
	||coalesce(school,'')) 
);
