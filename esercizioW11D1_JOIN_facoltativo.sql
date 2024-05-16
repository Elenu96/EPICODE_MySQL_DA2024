/* Cominciate facendo un’analisi esplorativa del database, ad esempio: 
- Fate un elenco di tutte le tabelle. 
- Visualizzate le prime 10 righe della tabella Album. 
- Trovate il numero totale di canzoni della tabella Tracks. 
- Trovate i diversi generi presenti nella tabella Genere. */

# Recuperate il nome di tutte le tracce e del genere associato.

SELECT track.name, genre.Name
FROM genre JOIN track ON genre.GenreId = track.GenreId;


# Recuperate il nome di tutti gli artisti che hanno almeno un album nel database. 
# Esistono artisti senza album nel database?

SELECT DISTINCT artist.Name
FROM artist JOIN album ON artist.ArtistId=album.ArtistId;

SELECT artist.Name, album.AlbumId
FROM artist LEFT JOIN album ON artist.ArtistId=album.ArtistId;

# Recuperate il nome di tutte le tracce, del genere associato e della tipologia di media. 
# Esiste un modo per recuperare il nome della tipologia di media?

SELECT 
    track.Name AS traccia,
    genre.Name AS genere,
    mediatype.Name AS mediatype
FROM
    genre
        RIGHT JOIN
    track ON genre.GenreId = track.GenreId
        LEFT JOIN
    mediatype ON track.MediaTypeId = mediatype.MediaTypeId;

# Elencate i nomi di tutti gli artisti e dei loro album.

SELECT artist.Name AS NomeArtista, album.Title AS TitoloAlbum
FROM artist JOIN album ON artist.ArtistId=album.ArtistId;
