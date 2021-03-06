import React from 'react';

import styles from './Page.css';

export default function Page({ children }) {
  return (
    <div className={styles.page}>
      <div className={styles.content}>{children}</div>
    </div>
  );
}
