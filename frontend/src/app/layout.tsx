import type { Metadata } from 'next'
import { Providers } from './providers'
import './globals.css'

export const metadata: Metadata = {
  title: 'DAOVault - DAO',
  description: 'DAO with encrypted proposals',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body><Providers>{children}</Providers></body>
    </html>
  )
}

