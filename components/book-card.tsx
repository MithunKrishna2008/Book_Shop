"use client"

import { ShoppingCart } from "lucide-react"
import { useState } from "react"

interface Book {
  id: string
  title: string
  author: string
  price: number
  category: string
  cover: string
}

interface BookCardProps {
  book: Book
  onAddToCart: () => void
}

export default function BookCard({ book, onAddToCart }: BookCardProps) {
  const [isAdded, setIsAdded] = useState(false)

  const handleAddClick = () => {
    onAddToCart()
    setIsAdded(true)
    setTimeout(() => setIsAdded(false), 1500)
  }

  return (
    <div className="bg-card rounded-lg overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-2 group">
      <div className="relative overflow-hidden h-60 bg-muted">
        <img
          src={book.cover || "/placeholder.svg"}
          alt={book.title}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />
        <span className="absolute top-3 right-3 bg-accent text-accent-foreground text-xs font-semibold px-3 py-1 rounded-full">
          {book.category}
        </span>
      </div>

      <div className="p-4">
        <h3 className="font-bold text-foreground line-clamp-2 mb-1">{book.title}</h3>
        <p className="text-sm text-muted-foreground mb-3">{book.author}</p>

        <div className="flex items-center justify-between">
          <span className="text-lg font-bold text-primary">${book.price.toFixed(2)}</span>
          <button
            onClick={handleAddClick}
            className={`p-2 rounded-lg transition-all duration-300 ${
              isAdded
                ? "bg-accent text-accent-foreground"
                : "bg-muted hover:bg-primary hover:text-primary-foreground text-foreground"
            }`}
            aria-label={`Add ${book.title} to cart`}
          >
            <ShoppingCart className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  )
}
