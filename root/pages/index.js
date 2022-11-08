import React, { useState, useEffect } from 'react'
import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
//Client Folder
import cardJSON from './../../client/config/clientConfig.json'  assert {type: 'json'};
export default function Home() { 
  const [clientFolder, setClientFolder] = useState(cardJSON);
  useEffect(()=>{
    setClientFolder(cardJSON);
  }, [cardJSON])
  return (
    <div className={styles.container}>
      <Head>
        <title>Master App</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        Content {clientFolder.clientJSON.accountName}
        <h1>{clientFolder.clientJSON.title}</h1>
        <button style={{backgroundColor: "red", padding: '.5rem', color: 'white'}}>Button</button>
        <br />
        <button style={{backgroundColor: "blue", padding: '.5rem', color: 'white'}}>New Button</button>
      </main>

    </div>
  )
}
