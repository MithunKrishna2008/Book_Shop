"use client"

import { X, Trash2 } from "lucide-react"

interface CartItem {
  id: string
  title: string
  author: string
  price: number
  quantity: number
}

interface CartProps {
  cart: CartItem[]
  onClose: () => void
  onUpdateQuantity: (id: string, quantity: number) => void
  onRemove: (id: string) => void
}

export default function Cart({ cart, onClose, onUpdateQuantity, onRemove }: CartProps) {
  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0)

  return (
    <div className="fixed inset-0 z-50 overflow-hidden">
      <div className="absolute inset-0 bg-black/50" onClick={onClose} />

      <div className="absolute right-0 top-0 h-full w-full max-w-md bg-card shadow-xl flex flex-col">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-xl font-bold text-foreground">Shopping Cart</h2>
          <button onClick={onClose} className="p-2 hover:bg-muted rounded-lg transition" aria-label="Close cart">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto p-6 space-y-4">
          {cart.length === 0 ? (
            <p className="text-muted-foreground text-center py-8">Your cart is empty</p>
          ) : (
            cart.map((item) => (
              <div key={item.id} className="flex gap-4 p-4 bg-background rounded-lg">
                <div className="flex-1">
                  <h3 className="font-semibold text-foreground">{item.title}</h3>
                  <p className="text-sm text-muted-foreground mb-2">{item.author}</p>
                  <p className="font-bold text-primary">${item.price.toFixed(2)}</p>
                </div>

                <div className="flex flex-col items-end gap-2">
                  <button
                    onClick={() => onRemove(item.id)}
                    className="p-1 hover:bg-destructive/10 rounded transition"
                    aria-label="Remove item"
                  >
                    <Trash2 className="w-4 h-4 text-destructive" />
                  </button>

                  <div className="flex items-center gap-2 border border-border rounded-lg">
                    <button
                      onClick={() => onUpdateQuantity(item.id, item.quantity - 1)}
                      className="w-6 h-6 hover:bg-muted"
                    >
                      −
                    </button>
                    <span className="w-6 text-center text-sm font-semibold">{item.quantity}</span>
                    <button
                      onClick={() => onUpdateQuantity(item.id, item.quantity + 1)}
                      className="w-6 h-6 hover:bg-muted"
                    >
                      +
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        <div className="border-t border-border p-6 space-y-4 bg-background">
          <div className="flex justify-between text-lg font-bold text-foreground">
            <span>Total:</span>
            <span className="text-primary">${total.toFixed(2)}</span>
          </div>
          <button className="w-full bg-primary text-primary-foreground py-3 rounded-lg font-semibold hover:opacity-90 transition">
            Checkout
          </button>
        </div>
      </div>
    </div>
  )
}
