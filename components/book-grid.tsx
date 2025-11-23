"use client"

import BookCard from "./book-card"

interface Book {
  id: string
  title: string
  author: string
  price: number
  category: string
  cover: string
}

interface BookGridProps {
  onAddToCart: (book: Book) => void
}

const books: Book[] = [
  {
    id: "1",
    title: "The Midnight Library",
    author: "Matt Haig",
    price: 15.99,
    category: "Fiction",
    cover: "/book-midnight-library.jpg",
  },
  {
    id: "2",
    title: "Atomic Habits",
    author: "James Clear",
    price: 16.99,
    category: "Self-Help",
    cover: "/book-atomic-habits.jpg",
  },
  {
    id: "3",
    title: "The Silent Patient",
    author: "Alex Michaelides",
    price: 14.99,
    category: "Thriller",
    cover: "/book-silent-patient.jpg",
  },
  {
    id: "4",
    title: "Project Hail Mary",
    author: "Andy Weir",
    price: 17.99,
    category: "Science Fiction",
    cover: "/book-project-hail-mary.jpg",
  },
  {
    id: "5",
    title: "Educated",
    author: "Tara Westover",
    price: 18.99,
    category: "Memoir",
    cover: "/book-educated.jpg",
  },
  {
    id: "6",
    title: "The Seven Husbands",
    author: "Taylor Jenkins Reid",
    price: 17.99,
    category: "Fiction",
    cover: "/book-seven-husbands.jpg",
  },
  {
    id: "7",
    title: "Klara and the Sun",
    author: "Kazuo Ishiguro",
    price: 16.99,
    category: "Science Fiction",
    cover: "/book-klara-sun.jpg",
  },
  {
    id: "8",
    title: "The Invisible Life",
    author: "Lisa See",
    price: 16.99,
    category: "Historical Fiction",
    cover: "/book-invisible-life.jpg",
  },
]

export default function BookGrid({ onAddToCart }: BookGridProps) {
  return (
    <section id="books" className="py-20 bg-background">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold mb-4 text-foreground">Featured Collection</h2>
          <p className="text-muted-foreground text-lg">Browse our curated selection of bestsellers and hidden gems</p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {books.map((book) => (
            <BookCard key={book.id} book={book} onAddToCart={() => onAddToCart(book)} />
          ))}
        </div>
      </div>
    </section>
  )
}
