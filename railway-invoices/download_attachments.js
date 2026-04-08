import Imap from 'imap';
import { simpleParser } from 'mailparser';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const account = process.env.QQ_EMAIL_ACCOUNT;
const authCode = process.env.QQ_EMAIL_AUTH_CODE;

if (!account || !authCode) {
  console.error('请设置环境变量 QQ_EMAIL_ACCOUNT 和 QQ_EMAIL_AUTH_CODE');
  process.exit(1);
}

const imapConfig = {
  user: account,
  password: authCode,
  host: 'imap.qq.com',
  port: 993,
  tls: true,
  tlsOptions: { rejectUnauthorized: false },
};

const UIDS = [2339, 2342, 2341, 2340, 2338, 2337, 2336, 2335];
const OUTPUT_DIR = '/root/.openclaw/workspace/railway-invoices/attachments';

function openInbox(imap) {
  return new Promise((resolve, reject) => {
    imap.openBox('INBOX', false, (err, box) => {
      if (err) reject(err);
      else resolve(box);
    });
  });
}

async function fetchEmailWithAttachments(uid) {
  const imap = new Imap(imapConfig);
  
  return new Promise((resolve, reject) => {
    imap.once('error', reject);
    imap.once('end', () => resolve(null));
    imap.once('ready', () => {
      openInbox(imap)
        .then(() => {
          const fetch = imap.fetch(uid, { bodies: '', struct: true });
          fetch.on('message', (msg) => {
            let allChunks = [];
            let attachments = [];
            let parsed = null;
            
            msg.on('body', (stream, info) => {
              const chunks = [];
              stream.on('data', (chunk) => chunks.push(chunk));
              stream.on('end', async () => {
                const buffer = Buffer.concat(chunks);
                try {
                  parsed = await simpleParser(buffer);
                  attachments = parsed.attachments || [];
                  console.log(`UID ${uid}: found ${attachments.length} attachments`);
                  
                  for (const att of attachments) {
                    const filename = att.filename || `attachment_${uid}`;
                    const ext = path.extname(filename) || '.pdf';
                    // Parse date from email for naming
                    const dateMatch = parsed.text?.match(/(\d{4}年\d{1,2}月\d{1,2}日)/);
                    const trainMatch = parsed.text?.match(/(C\d+|G\d+|D\d+|K\d+)/);
                    const fromMatch = parsed.text?.match(/([^\s-]+-[^\s]+?)\s+票价/);
                    
                    let shortName = `${uid}`;
                    if (trainMatch) shortName = `${trainMatch[1]}`;
                    
                    const safeName = `${shortName}${ext}`;
                    const outPath = path.join(OUTPUT_DIR, safeName);
                    
                    fs.writeFileSync(outPath, att.content);
                    console.log(`  -> saved: ${safeName} (${att.content.length} bytes)`);
                  }
                } catch(e) {
                  console.error(`  parse error: ${e.message}`);
                }
                imap.end();
              });
            });
            msg.on('error', (e) => {
              console.error(`msg error UID ${uid}: ${e.message}`);
              imap.end();
            });
          });
          fetch.on('error', (e) => {
            console.error(`fetch error UID ${uid}: ${e.message}`);
            imap.end();
          });
          fetch.once('end', () => {});
        })
        .catch((e) => {
          console.error(`openBox error: ${e.message}`);
          imap.end();
        });
    });
    imap.connect();
  });
}

async function main() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  
  for (const uid of UIDS) {
    try {
      await fetchEmailWithAttachments(uid);
      await new Promise(r => setTimeout(r, 1000)); // avoid rate limit
    } catch(e) {
      console.error(`Error processing UID ${uid}: ${e.message}`);
    }
  }
  console.log('Done!');
}

main();
