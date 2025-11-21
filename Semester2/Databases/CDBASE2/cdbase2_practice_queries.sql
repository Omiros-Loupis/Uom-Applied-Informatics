-- Τα παρακάτω αιτήματα μπορείτε να τα δοκιμάσετε στη βάση cdbase2.
-- Η βάση αυτή είναι πανομοιότυπη με την cdbase αλλά έχει άλλα
-- περιεχόμενα. Πιο συγκεκριμένα, αποτελείται από 29 cd, εκ των οποίων
-- τα 27 είναι συλλογές και τα 2 προσωπικά cd καλλιτεχνών.

-- Η βάση υπάρχει στα DBMS που φιλοξενούνται στο db.mad.uom.gr
-- http://db.mad.uom.gr (για σύνδεση μέσω cloudbeaver)
-- http://db.mad.uom.gr/adminer (για σύνδεση μέσω adminer)

-- Σας δίνονται και τα dumps της βάσης σε MySQL/MariaDB και PostgreSQL
-- για να τη φορτώσετε στον δικό σας server αν το επιθυμείτε.

-- Μελετήστε τα παρακάτω αιτήματα πολύ καλά. Για κάθε αίτημα δίνουμε πολλαπλές
-- λύσεις, για παράδειγμα, στο αίτημα 10.9 δίνουμε 7 διαφορετικές λύσεις. Αν τα 
-- καταλάβετε όλα, τότε είστε σε πολύ καλό δρόμο να γίνετε αστέρια στην SQL!


-- 10.1 Τίτλοι τραγουδιών που αρχίζουν από "Α" και εμφανίζονται ως tracks, 
-- στα αντίστοιχα CDs, σε θέσεις μικρότερες της 10ης.

-- με in:
select stitle 
from song
where stitle like 'A%' and 
      sid in (select sid from track where pos<10);

-- με exists:
select stitle 
from song
where stitle like 'A%' and 
      exists (select * from track where track.sid=song.sid and pos<10);

-- με σύζευξη (δείτε ότι εδώ μπορούμε να πάρουμε στην απάντηση και πεδία του track, όπως η θέση)
select stitle, pos
from song, track 
where song.sid=track.sid and 
      stitle like 'A%' and pos<10;
 
-- με σύζευξη (σύνταξη inner join - όπως είπαμε στο μάθημα, το keyword inner είναι περιττό)  
select stitle, pos
from song inner join track on song.sid=track.sid
where stitle like 'A%' and pos<10;




-- 10.2 Ονόματα ερμηνευτών που συμμετέχουν σε cd της εταιρίας Atlantic.

-- τριπλή σύζευξη με 4 πίνακες
select distinct performer.name
from performer, track, cd, company
where performer.pid=track.pid and 
      track.cid=cd.cid and 
      cd.comid=company.comid and 
      company.name='Atlantic';

-- το ίδιο αλλά με inner joins (οι παρενθέσεις δεν είναι υποχρεωτικές)
select distinct performer.name
from ((performer inner join track on performer.pid=track.pid) 
                 inner join cd on track.cid=cd.cid) 
                 inner join company on cd.comid=company.comid
where company.name='Atlantic';

-- το ίδιο με τριπλή εμφώλευση με in (προφανώς θα μπορούσαμε να χρησιμοποιήσουμε
-- οποιοδήποτε συνδυασμό με in και exists)
select name
from performer
where pid in (select pid
              from track
              where cid in (select cid
                            from cd
                            where comid in (select comid
                                            from company
                                            where name='Atlantic')));




-- 10.3 Τα ονόματα των εταιριών που κυκλοφόρησαν cd μέσα στο 1996.

-- με εμφώλευση με in
select name
from company
where comid in (select comid
                from cd
                where year='1996');
               
-- με σύζευξη (εδώ θέλει και το keyword distinct για την απομάκρυνση των διπλότυπων)
select name
from company, cd
where company.comid=cd.comid and year='1996';




-- 10.4 Τα ονόματα (name) όλων των ερμηνευτών οι οποίοι εκτελούν εννέα ή περισσότερα track
-- από αυτά που καταχωρεί η βάση.

-- η δεύτερη select βρίσκει τους κωδικούς ερμηνευτών που εκτελούν >=9 track
select name
from performer 
where pid in (select pid 
              from track
              group by pid
              having count(*)>8);

-- η δεύτερη select μετρά τα track που εκτελεί ο κάθε ένας ερμηνευτής
select name
from performer 
where (select count(*) from track where track.pid=performer.pid) > 8;




-- 10.5 Οι τίτλοι των cd που περιέχουν πάνω από 21 tracks.

-- η δεύτερη select βρίσκει τους κωδικούς cd με πάνω από 21 tracks
select ctitle
from cd
where cid in (select cid
              from track
              group by cid
              having count(*)>21);

-- λύση χακεράδικη: η δεύτερη select βρίσκει τα cd που έχουν track στην 22 θέση, άρα έχουν >21 tracks
select ctitle
from cd
where cid in (select cid
              from track
              where pos=22);




-- 10.6 Τα ονόματα (name) των ερμηνευτών οι οποίοι συμπεριλαμβάνονται σε ΟΛΑ τα CDs της εταιρίας με κωδικό 2.

-- υλοποίηση της διαίρεσης με διπλή άρνηση, δηλαδή, οι ερμηνευτές για τους οποίους δεν υπάρχει cd της 
-- εταιρίας 2 που να μην περιέχει track τους
select name
from performer
where not exists (select *
                  from cd
                  where comid=2 and 
                        not exists (select *
                                    from track
                                    where track.pid=performer.pid and track.cid=cd.cid));
                                                        
-- η δεύτερη select βρίσκει όλα τα cd της εταιρίας 2 και η τρίτη όλα τα cd του κάθε ερμηνευτή, οπότε η 
-- διαφορά τους είναι κενή όταν ο ερμηνευτής συμμετέχει σε όλα τα cd της δεύτερης select
select name
from performer
where not exists ((select cid
                   from cd
                   where comid=2)
                  except
                  (select cid
                   from track
                   where track.pid=performer.pid));




-- 10.7 Ονόματα ερμηνευτών που κυκλοφόρησαν track σε όλες τις καταχωρισμένες χρονιές πριν το 1990 (δηλαδή 
-- υπάρχει τουλάχιστον ένα track τους σε κάποιο cd για όλες αυτές τις χρονιές).

-- οι ερμηνευτές για τους οποίους δεν υπάρχει καταχωρισμένη χρονιά < 1990 στην οποία να μην έχει 
-- κυκλοφορήσει cd με track που εκτελούν
select name
from performer
where not exists (select *
                  from cd
                  where year < 1990 and 
                        year not in (select year
                                     from cd
                                     where cid in (select cid
                                                   from track
                                                   where pid=performer.pid)));

-- το ίδιο με μικρή παραλλαγή: η δεύτερη select βρίσκει όλες τις χρονιές στις οποίες έχει κυκλοφορήσει cd 
-- πριν το 1990 και η τρίτη select βρίσκει όλες τις χρονιές στις οποίες κυκλοφόρησε cd με track που εκτελεί 
-- ένας συγκεκριμένος ερμηνευτής, οπότε η διαφορά είναι κενή όταν ο συγκεκριμένος ερμηνευτής έχει 
-- κυκλοφορήσει track σε όλες τις χρονιές πριν το 1990
select name
from performer
where not exists ((select year
                   from cd
                   where year < 1990)
                  except
                  (select year
                   from track inner join cd on track.cid=cd.cid
                   where track.pid=performer.pid));
                   



-- 10.8 Οι τίτλοι των cd που έχουν την αποκλειστικότητα σε ένα τουλάχιστον track τους, δηλαδή, όπου το 
-- αντίστοιχο τραγούδι δεν περιέχεται σε άλλο cd.

-- τα cd που έχουν track (t1.cid=cd.cid) που αντιστοιχεί σε τραγούδι που δεν υπάρχει (t1.sid=t2.sid) και σε 
-- άλλο cd (t1.cid<>t2.cid), δηλαδή, αυτό ακριβώς που διατυπώνει το ερώτημα
select ctitle
from cd
where exists (select *
              from track t1
              where t1.cid=cd.cid and 
                    not exists (select * 
                                from track t2
                                where t1.sid=t2.sid and t1.cid<>t2.cid));

-- το ίδιο με in/not in αντί exists/not exists
select ctitle
from cd
where cid in (select cid
              from track t1
              where sid not in (select sid 
                                from track t2
                                where t1.cid<>t2.cid));

-- η δεύτερη select βρίσκει τα τραγούδια του κάθε ενός cd και η τρίτη όλα τα τραγούδια με μοναδική εμφάνιση, 
-- οπότε η τομή είναι μη κενή όταν το συγκεκριμένο cd έχει τουλάχιστον ένα αποκλειστικό τραγούδι
select ctitle
from cd
where exists ((select sid
               from track
               where track.cid=cd.cid)
              intersect
              (select sid
               from track
               group by sid
               having count(*)=1));

-- η δεύτερη select βρίσκει τα τραγούδια του κάθε ενός cd και η τρίτη όλα τα τραγούδια με μη μοναδική 
-- εμφάνιση, οπότε η διαφορά είναι μη κενή όταν το συγκεκριμένο cd έχει τουλάχιστον ένα αποκλειστικό τραγούδι
select ctitle
from cd
where exists ((select sid
               from track
               where track.cid=cd.cid)
              except
              (select sid
               from track
               group by sid
               having count(*)>1));




-- 10.9 Οι τίτλοι των cd στα οποία δεν υπάρχει τραγούδι που να υπάρχει σε άλλο cd. 

-- τα cd που δεν έχουν track (t1.cid=cd.cid) που να αντιστοιχεί σε τραγούδι που υπάρχει (t1.sid=t2.sid) και 
-- σε άλλο cd (t1.cid<>t2.cid), δηλαδή, αυτό ακριβώς που διατυπώνει το ερώτημα
select ctitle
from cd
where not exists (select *
                  from track t1
                  where t1.cid=cd.cid and 
                        exists (select * 
                                from track t2
                                where t1.cid<>t2.cid and t1.sid=t2.sid));

-- το ίδιο με not in/in αντί not exists/exists
select ctitle
from cd
where cid not in (select cid 
                  from track t1
                  where sid in (select sid 
                                from track t2
                                where t1.cid<>t2.cid));

-- ξανά το ίδιο με not exists/in (προφανώς μπορούν να γίνουν όλοι οι δυνατοί συνδυασμοί)                                  
select ctitle
from cd
where not exists (select *
                  from track t1
                  where t1.cid=cd.cid and 
                        t1.sid in (select t2.sid 
                                   from track t2
                                   where t1.cid<>t2.cid));

-- ξανά το ίδιο με not exists και σύζευξη: η εμφώλευση της 2ης και 3ης select μετατράπηκε σε σύζευξη
select ctitle
from cd
where not exists (select *
                  from track t1, track t2
                  where t1.sid=t2.sid and t1.cid<>t2.cid and t1.cid=cd.cid);
                  
-- αφού το αρχικό ερώτημα μπορεί να διατυπωθεί και ως "τα cd που όλα τα τραγούδια τους είναι αποκλειστικά" 
-- έχουμε την περίπτωση διαίρεσης με δυο αρνήσεις: τα cd που δεν έχουν τραγούδι που να μην είναι αποκλειστικό
select ctitle
from cd
where cid not in (select cid
                  from track
                  where sid not in (select sid
                                    from track
                                    group by sid
                                    having count(*)=1));

-- Είναι ενδιαφέρον να δείτε τις ομοιότητες και διαφορές των παρακάτω δυο λύσεων με τις
-- αντίστοιχες λύσεις του ερωτήματος 10.8

-- η δεύτερη select βρίσκει τα τραγούδια του κάθε ενός cd και η τρίτη όλα τα τραγούδια με μοναδική εμφάνιση,
-- οπότε η διαφορά είναι κενή όταν το συγκεκριμένο cd έχει όλα τα τραγούδια του αποκλειστικά
select ctitle
from cd
where not exists ((select sid
                   from track
                   where track.cid=cd.cid)
                  except
                  (select sid
                   from track
                   group by sid
                   having count(*)=1));

-- η δεύτερη select βρίσκει τα τραγούδια του κάθε ενός cd και η τρίτη όλα τα τραγούδια με μη μοναδική εμφάνιση,
-- οπότε η τομή είναι κενή όταν το συγκεκριμένο cd έχει όλα τα τραγούδια του αποκλειστικά
select ctitle
from cd
where not exists ((select sid
                   from track
                   where track.cid=cd.cid)
                  intersect
                  (select sid
                   from track
                   group by sid
                   having count(*)>1));


           

-- 10.10 Οι τίτλοι των cd που περιέχουν μόνο μη αποκλειστικά τραγούδια (δηλαδή, όλα τα τραγούδια
-- υπάρχουν και σε κάποιο άλλο cd).

-- Στα παρακάτω μελετήστε τις ομοιότητες και διαφορές με το 10.9. Μπορούμε και εδώ να έχουμε
-- αντίστοιχες λύσεις με αυτές του ερωτήματος 10.9. Ενδεικτικά:

-- το ερώτημα μπορεί να διατυπωθεί και ως "οι τίτλοι των cd που δεν έχουν τραγούδι που να μην υπάρχει
-- και σε άλλο cd", οπότε η παρακάτω λύση βρίσκει τα cd που δεν έχουν τραγούδι (t1.cid=cd.cid) που να
-- μην υπάρχει (t1.sid=t2.sid) και σε άλλο cd (t1.cid<>t2.cid), δηλαδή, αυτό ακριβώς που διατυπώνει το ερώτημα
select ctitle
from cd
where not exists (select *
                  from track t1
                  where t1.cid=cd.cid and 
                        not exists (select * 
                                    from track t2
                                    where t1.cid<>t2.cid and t1.sid=t2.sid));
                                                   
-- επίσης, το ερώτημα μπορεί να διατυπωθεί και ως "οι τίτλοι των cd που όλα τα τραγούδια τους είναι
-- μη αποκλειστικά", οπότε πρόκειται για διαίρεση και μια λύση είναι η διπλή άρνηση "οι τίτλοι
-- των cd που δεν έχουν τραγούδι που να μην είναι μη αποκλειστικό"
select ctitle
from cd
where cid not in (select cid
                  from track
                  where sid not in (select sid
                                    from track
                                    group by sid
                                    having count(*)>1));

-- υλοποίηση με διαφορά (γίνεται και με τομή)
select ctitle
from cd
where not exists ((select sid
                   from track
                   where track.cid=cd.cid)
                  except
                  (select sid
                   from track
                   group by sid
                   having count(*)>1));




-- 10.11 Τα ονόματα ερμηνευτών που έχουν μόνο "solo" cd (δηλαδή μόνο cd στα οποία υπάρχουν
-- μόνο δικά τους τραγούδια και όχι άλλων ερμηνευτών).

-- Μπορούμε να διατυπώσουμε το ερώτημα αυτό κατ' αντιστοιχία του 10.9: "Οι ερμηνευτές που δεν έχουν
-- cd που να περιέχει άλλους ερμηνευτές", οπότε προκύπτουν πάλι όλες οι αντίστοιχες λύσεις. Ενδεικτικά:

select name
from performer
where pid not in (select pid
                  from track t1
                  where cid in (select cid
                                from track t2
                                where t1.pid<>t2.pid));

select name
from performer
where not exists (select *
                  from track t1 inner join track t2 on t1.cid=t2.cid
                  where performer.pid=t1.pid and t1.pid<>t2.pid);




-- 10.12 Αν μας ζητούσαν τους ερμηνευτές που έχουν τουλάχιστον ένα "solo" cd, ορίστε και μια φευγάτη λύση:
-- η δεύτερη select ομαδοποιεί τα τραγούδια ως προς cd και performer και κρατά εκείνα τα group που έχουν
-- πλήθος τραγουδιών ίσο με το πλήθος τραγουδιών του συγκεκριμένου cd,
-- άρα το cd περιέχει μόνο τραγούδια ενός ερμηνευτή!
select name
from performer
where pid in (select pid
              from track t1
              group by cid, pid
              having count(*)=(select count(*) from track t2 where t2.cid=t1.cid));


